Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 51A5C7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 07:21:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CBB58F8070
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 05:21:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Lo8moVhLrSsrS4Cy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 05:21:05 -0800 (PST)
Message-ID: <52A1CF22.106@oracle.com>
Date: Fri, 06 Dec 2013 17:20:34 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: nfs vs xfstests 193
References: <20131106115648.GA24804@infradead.org>
In-Reply-To: <20131106115648.GA24804@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Vasily Isaenko <vasily.isaenko@oracle.com>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com


On 11/06/2013 03:56 PM, Christoph Hellwig wrote:
> I've noticed that xfstests 193 fails when run over NFS talking to an
> XFS-based Linux server.  The test checks that we behave correctly
> vs Posix 1003.1 for the various operations that end up in ->setattr.
>
> Without the no_root_squash export flag we're not even able to run
> something resembling the test as we get permission problems all through
> it, see the first attachment for details.
>
> With the root_squash export op we fail to clear the setuid/setgid
> bits in various truncate and chown subtests, see the second attachment
> for details.
Hi!

I've come across  the same issue. But NFS server is backed by ext4 file 
system in my environment.

The test case quotes POSIX:

"If the specified file is a regular file, one or more of the S_IXUSR, 
S_IXGRP, or S_IXOTH bits of the
file mode are set, and the process has appropriate privileges, it is 
implementation-defined whether the set-user-ID and set-group-ID
bits are altered."

So the difference that what we have now:

between nfs:
~# touch file; chmod ug+s file; chmod u+x file; ls -l file; chown root 
file; ls -l file; rm -f file
-rwsr-Sr-- 1 root root 0 Dec  6 04:49 file
-rwsr-Sr-- 1 root root 0 Dec  6 04:49 file

and ext3, ext4, xfs, btrfs:
~# touch file; chmod ug+s file; chmod u+x file; ls -l file; chown root 
file; ls -l file; rm -f file
-rwsr-Sr-- 1 root root 0 Dec  6 04:49 file
-rwxr-Sr-- 1 root root 0 Dec  6 04:49 file

is not a violation of this POSIX statement. But It's just an 
"implementation-defined" behaviour.

I suppose that the difference raises because of this part of code in 
fs/nfsd/vfs.c:

         /* Revoke setuid/setgid on chown */
         if (!S_ISDIR(inode->i_mode) &&
             (((iap->ia_valid & ATTR_UID) && !uid_eq(iap->ia_uid, 
inode->i_uid)) ||
              ((iap->ia_valid & ATTR_GID) && !gid_eq(iap->ia_gid, 
inode->i_gid)))) {
                 iap->ia_valid |= ATTR_KILL_PRIV;
                 if (iap->ia_valid & ATTR_MODE) {
                         /* we're setting mode too, just clear the s*id 
bits */
                         iap->ia_mode &= ~S_ISUID;
                         if (iap->ia_mode & S_IXGRP)
                                 iap->ia_mode &= ~S_ISGID;
                 } else {
                         /* set ATTR_KILL_* bits and let VFS handle it */
                         iap->ia_valid |= (ATTR_KILL_SUID | ATTR_KILL_SGID);
                 }
         }

uid_eq() and gid_eq() checkings allow removal of s*id bits only if the 
owner/group of the file is changed during chown().

I.e. on nfs:
~# touch file; chmod ug+s file; chmod u+x file; ls -l file; chown bin 
file; ls -l file; rm -f file
-rwsr-Sr-- 1 root root 0 Dec  6 05:02 file
-rwxr-Sr-- 1 bin root 0 Dec  6 05:02 file

Is it acceptable to change NFS kernel server behaviour by removal of 
!uid_eq(iap->ia_uid, inode->i_uid) and !gid_eq(iap->ia_gid, 
inode->i_gid) from the condition above?

Just to make the behaviour more consistent between NFS and other "local" 
file systems as It was done by
commit 
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0953e620de0538cbd081f1b45126f6098112a598

Thank you!



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
