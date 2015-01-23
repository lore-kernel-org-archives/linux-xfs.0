Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B87127F66
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 09:49:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4DCC030405F
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 07:49:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kOVCRWf0No9cWG9S for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 07:49:36 -0800 (PST)
Message-ID: <54C26D8F.1040402@sandeen.net>
Date: Fri, 23 Jan 2015 09:49:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Change sector size on existing partition
References: <54C246EC.90207@xtremenitro.org> <54C268ED.2000801@sandeen.net>
	<54C26B5F.7000803@xtremenitro.org>
In-Reply-To: <54C26B5F.7000803@xtremenitro.org>
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
To: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>, xfs@oss.sgi.com

On 1/23/15 9:40 AM, Dewangga Bachrul Alam wrote:
> Hi,
> 
> I'm sorry, didnt fill any information here, but here is my nodes details.
> 
> $ uname -a
> Linux catalyst-db01.jkt3d.xxx 2.6.32-504.3.3.el6.x86_64 #1 SMP Wed Dec
> 17 01:55:02 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> $ cat /etc/redhat-release
> CentOS release 6.6 (Final)
> 
> The xfs and partition table build from anaconda from first install,
> instalation came from CentOS 6.6. But it's weird, only this node has 4k
> sector size, the others is 512.
> 
> catalyst-db01$ yum history info 1 | grep xfsprogs | fpaste
> Uploading (0.2KiB)...
> http://ur1.ca/jihyu -> http://paste.fedoraproject.org/173606/27434142

so xfsprogs v3.1.1

This went into v3.1.8:

commit 287d168b550857ce40e04b5f618d7eb91b87022f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Mar 1 22:46:35 2012 -0600

    mkfs.xfs: properly handle physical sector size
    
    This splits the fs_topology structure "sectorsize" into
    logical & physical, and gets both via blkid_get_topology().
    
    This primarily allows us to default to using the physical
    sectorsize for mkfs's "sector size" value, the fundamental
    size of any IOs the filesystem will perform.
    
    We reduce mkfs.xfs's "sector size" to logical if
    a block size < physical sector size is specified.
    This is suboptimal, but permissable.
    
    For block size < sector size, differentiate the error
    message based on whether the sector size was manually
    specified, or deduced.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

but was backported to the RHEL6 xfsprogs:

* Tue Sep 25 2012 Eric Sandeen <sandeen@redhat.com> 3.1.1-8
- mkfs.xfs: better handle misaligned 4k devices (#836433)
- mkfs.xfs: default to physical sectorsize (#836433)

So, not *exactly* a bug, because the assumption that 512-byte
DIO will always work is not a good one, but the commit I mentioned
in my first email will let 512-byte DIOs work again.

I'd tell you to file a bug with your RHEL support people, but
Centos ... ;)  We probably should get that kernel commit into RHEL6
if possible.  I'm kind of surprised we haven't seen other reports.

But, if you ever wind up with hard 4k/4k drives, your database
still won't work.  On any filesystem.  :)

If you don't mind following up with this informtation in the other
forum, that might help others.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
