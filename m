Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 81C327F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 21:18:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 508238F8049
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 19:18:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6xcJfMdUElZPMZyW for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 19:18:21 -0700 (PDT)
Message-ID: <51CCF26C.1030908@sandeen.net>
Date: Thu, 27 Jun 2013 22:18:20 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
	<20130627144814.GM20932@sgi.com> <20130627190831.GN20932@sgi.com>
In-Reply-To: <20130627190831.GN20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 6/27/13 3:08 PM, Ben Myers wrote:
> Hey Dave,
> 
> On Thu, Jun 27, 2013 at 09:48:14AM -0500, Ben Myers wrote:
>> On Thu, Jun 27, 2013 at 04:04:45PM +1000, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Because it's horribly out of date.
>>>
>>> And mark various deprecated options as deprecated and give them a
>>> removal date.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>>
>> Regarding removal of these mount options and sysctls:  initially these all look
>> pretty reasonable but we need to be very careful here.  I've read some
>> discussions on lkml that seem to suggest that such interfaces which have been
>> exported to userspace shouldn't be removed at all.  Not that I want to keep
>> around a bunch of worn out interfaces...
>>
>> Applied.
> 
> On second thought... Not pushed.
> 
> I'm going to hold off on pushing this one to oss for now because I'm just not
> comfortable with it yet.  I can pull this in sans the removal notices if you
> want.  Lets discuss whether the removal of deprecated mount options and sysctls
> is acceptable before announcing an intention to remove them.  I'm trending no,
> but I can be flexible if this really is ok.

There's a long history of deprecating mount options - indeed, even entire
filesystems (smbfs)!  Here's a sampling:

5e2a4b25da232a2f4ce264a4b2ae113d0b2a799c btrfs: deprecate subvolrootid mount option
1b359204901e182b27aa9da432095cbe2cfd2512 cifs: remove support for deprecated "forcedirectio" and "strictcache" mount options
67c1f5295150eb86d065d57b4515a472ecbf008f cifs: add deprecation warning to sockopt=TCP_NODELAY option
43829731dd372d04d6706c51052b9dabab9ca356 workqueue: deprecate flush[_delayed]_work_sync()
09983b2fab80fa037b1dcf9a11de5a70df59ef7f cifs: add deprecation warnings to strictcache and forcedirectio
4d61cd6ec764368689fab3bd19e78d76c1e6b176 cifs: add a deprecation warning to CIFS_IOC_CHECKUMOUNT ioctl
f70486055ee351158bd6999f3965ad378b52c694 ext4: try to deprecate noacl and noxattr_user mount options
87f26807e91102f2526d59c0232bf020479c8d0c ext4: remove deprecation warnings for minix_df and grpid
789b4588da40cf572ef982bdc5d590ec1b0386fe cifs: warn about impending deprecation of legacy MultiuserMount code
93b8a5854f247138e401471a9c3b82ccb62ff608 xfs: remove the deprecated nodelaylog option
8bc4392a1e50f346e97f8777aaefd9cfc3d45c9f cifs: warn about deprecation of /proc/fs/cifs/OplockEnabled interface
4113c4caa4f355b8ff8b7ff0510c29c9d00d30b3 ext4: remove deprecated oldalloc
242d621964dd8641df53f7d51d4c6ead655cc5a6 xfs: deprecate the nodelaylog mount option
fbc854027c91fa2813ae7f9de43cc0b5c1119f41 ext3: remove deprecated oldalloc
be8f684d73d8d916847e996bf69cef14352872c6 oom: make deprecated use of oom_adj more verbose
49b28684fdba2c84a3b8e54aaa0faa9ce2e4f140 nfsd: Remove deprecated nfsctl system call and related code.
52ca0e84b05595cf74f1ff772b3f9807256b1b27 hugetlbfs: lessen the impact of a deprecation warning
e52eec13cd6b7f30ab19081b387813e03e592ae5 SYSFS: Allow boot time switching between deprecated and modern sysfs layout
1e1405673e4e40a94ed7620553eb440a21040402 nfsd: allow deprecated interface to be compiled out.
c67874f942e30039442d925b03793e0a46ddcddd nfsd: formally deprecate legacy nfsd syscall interface
51b1bd2ace1595b72956224deda349efa880b693 oom: deprecate oom_adj tunable
a4432345352c2be157ed844603147ac2c82f209c NFSv41: Deprecate nfs_client->cl_minorversion
437ca0fda3b442dff9e591581b5e1ffdfec24660 ext4: deprecate obsoleted mount options
ed58f8027945f1cf415bfe3805e1fa3fe8ed9edf fs/smbfs/inode.c: fix warning message deprecating smbfs
c773633916c66f8362ca01983d97bd33e35b743f deprecate smbfs in favour of cifs
8e9073ed027771bcdee4033eb900a3c09ac90a19 Deprecate a.out ELF interpreters
e10a4437cb37c85f2df95432025b392d98aac2aa [PATCH] Remove final references to deprecated "MAP_ANON" page protection flag
f1ddcaf3393b7a3871809b97fae90fac841a1f39 [CRYPTO] api: Remove deprecated interface
1ec320afdc9552c92191d5f89fcd1ebe588334ca [PATCH] add process_session() helper routine: deprecate old field

Marking as deprecated, and putting back into play if people REALLY care?
That's been done too:

87f26807e91102f2526d59c0232bf020479c8d0c ext4: remove deprecation warnings for minix_df and grpid

> I'm thinking of the 3.3 glusterfs and 3.8 pulseaudio reakeage.  And I would
> really like to have a nice holiday weekend. ;)

Is "reakage" a freudian slip?  :)  I dunno about PA, but the gluster thing
wasn't related to deprecation.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
