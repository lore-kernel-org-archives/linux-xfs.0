Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3A357F56
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:56:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD5FA8F8064
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 05:56:10 -0700 (PDT)
Received: from emvm-gh1-uea09.nsa.gov (emvm-gh1-uea09.nsa.gov [63.239.67.10])
	by cuda.sgi.com with ESMTP id bLCvyCZNUfUKAzfu for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 05:56:07 -0700 (PDT)
Message-ID: <534E7CDA.2060805@tycho.nsa.gov>
Date: Wed, 16 Apr 2014 08:51:38 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-3-git-send-email-bfoster@redhat.com>
	<20140415175033.GB26404@infradead.org>
	<534D90D0.9090805@tycho.nsa.gov>
	<20140415202222.GA10928@infradead.org>
	<534D94E4.8070606@tycho.nsa.gov>
In-Reply-To: <534D94E4.8070606@tycho.nsa.gov>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Paul Moore <paul@paul-moore.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>

On 04/15/2014 04:21 PM, Stephen Smalley wrote:
> On 04/15/2014 04:22 PM, Christoph Hellwig wrote:
>> On Tue, Apr 15, 2014 at 04:04:32PM -0400, Stephen Smalley wrote:
>>> Is there a reason that xfs_init_security() isn't called from the inode
>>> allocation function (e.g. xfs_ialloc), as in ext4 (__ext4_new_inode
>>> calls ext4_init_security and also calls ext4_init_acl)?  That would have
>>> ensured that tmpfile inodes would have been labeled without requiring a
>>> separate change and more generally ensures complete coverage for all inodes.
>>
>> Really just code structuring - we don't like callouts to high level VFS
>> functions from deep down in the guts of the filesystem.
>>
>>> For SELinux, we need the tmpfile inodes to be labeled at creation time,
>>> not just if linked into the namespace, since they may be shared via
>>> local socket IPC or inherited across a label-changing exec and since we
>>> revalidate access on transfer or use.
>>>
>>> Labeling based on the provided directory could be a bit random, although
>>> it will work out with current policy if the provided directory
>>> corresponds to existing tmpfile locations (e.g. /tmp, /var/tmp) and
>>> therefore already has a label associated with temporary files.
>>> Otherwise we might want some indication that it is a tmpfile passed into
>>> security_inode_init_security() so that we can always select a stable
>>> label irrespective of the directory.
>>
>> Just check for I_LINKABLE in i_flags.
> 
> Thanks, that should allow us to handle it cleanly in the security modules!

Maybe I spoke too soon.  IIUC, I_LINKABLE doesn't necessarily
distinguish tmpfiles from other files, as some tmpfiles may be linkable
and others not.  But what we want is a way to identify all tmpfiles when
security_inode_init_security() is called if we are going to label them
independently of the provided dir.

Also, in that situation, we would need to likewise distinguish them
during the create-time checking, i.e. when security_inode_create() is
called (from may_o_create), as we have to determine the label that will
be applied at that point for permission checking.  And there we do not
have the inode yet so we do not even have I_LINKABLE as a distinguisher.

So I think we need __O_TMPFILE or similar flag passed down to
may_o_create() -> security_inode_create() and to
security_inode_init_security() if we are going to label these files
independently of the provided directory.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
