Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B46147F52
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:30:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32940AC006
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:30:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xBgclayxjxHaWZZN for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 07:30:02 -0700 (PDT)
Message-ID: <52289569.1070107@sandeen.net>
Date: Thu, 05 Sep 2013 09:30:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: SGID inheritance in different file-systems
References: <52208DC0.2030805@oracle.com>
In-Reply-To: <52208DC0.2030805@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vasily Isaenko <vasily.isaenko@oracle.com>
Cc: xfs@oss.sgi.com

On 8/30/13 7:19 AM, Vasily Isaenko wrote:
> Dear XFS Members,
> =

> In the XFS test suite there is a test case generic/314 "Test SGID inherit=
ance on subdirectories".
> It is not specific to a particular filesystem thus selected for both xfs =
or ext4 test runs.
> In other words, the same behaviour is expected and enforced for XFS and E=
XT4.

Yep, and it passes on both of them, as well as on ext3, ext2, btrfs, and gf=
s2...

> However, I have been told that EXT4 and XFS may have different behaviour =
as the
> setgid-directory behavior is not guaranteed to work the same way on all f=
ilesystems.

"I have been told" ... I'm guessing that you have tested a filesystem which=
 doesn't
behave this way?  Which one?

> Shall XFS test case reflect that difference or enforcing the same behavio=
ur is appropriate?

If you have information that a filesystem exists which does not inherit SGI=
D, and
that this behavior is intentional and correct and standards-compliant, then=
 feel
free to submit a patch.

However, I think you'll need to have a convincing argument against the man =
pages.

chmod(2) says:

       S_ISGID  (02000)  set-group-ID   (set   process   effective   group =
 ID  on
                         execve(2); mandatory locking, as described  in  fc=
ntl(2);
                         take  a  new  file=92s  group  from  parent  direc=
tory,  as
                         described in chown(2) and mkdir(2))

mkdir(2) says:

       The newly created directory will be owned by the effective user ID  =
of  the
       process.   If  the  directory  containing the file has the set-group=
-ID bit
       set, or if the file system is mounted with BSD group  semantics  (mo=
unt  -o
       bsdgroups  or, synonymously mount -o grpid), the new directory will =
inherit
       the group ownership from its parent; otherwise it  will  be  owned  =
by  the
       effective group ID of the process.

and chown(2) says:

NOTES
       When  a  new  file  is  created (by, for example, open(2) or mkdir(2=
)), its
       owner is made the same as the file system user ID of the creating  p=
rocess.
       The  group of the file depends on a range of factors, including the =
type of
       file system, the options used to mount the file system, and whether =
or  not
       the set-group-ID permission bit is enabled on the parent directory. =
 If the
       file system supports  the  -o grpid  (or,  synonymously  -o bsdgroup=
s)  and
       -o nogrpid  (or,  synonymously  -o sysvgroups)  mount(8)  options, t=
hen the
       rules are as follows:

       * If the file system is mounted with -o grpid, then the group of a n=
ew file
         is made the same as that of the parent directory.

       * If the file system is mounted with -o nogrpid and the set-group-ID=
 bit is
         disabled on the parent directory, then the group of a new  file  i=
s  made
         the same as the process=92s file system GID.

       * If the file system is mounted with -o nogrpid and the set-group-ID=
 bit is
         enabled on the parent directory, then the group of a new file is m=
ade the
         same as that of the parent directory.

Thanks,
Eric

> Best regards,
> Vasily
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
