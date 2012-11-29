Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATNAvt8093285 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 17:10:57 -0600
Message-ID: <50B7EC0A.1050906@sgi.com>
Date: Thu, 29 Nov 2012 17:13:14 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: userspace release -rc2
References: <20121129224714.GK27055@sgi.com>
In-Reply-To: <20121129224714.GK27055@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 11/29/12 16:47, Ben Myers wrote:
> Hi,
>
> I've marked -rc2 for the userspace releases as a conversation starter.  See:
>
> git://oss.sgi.com/xfs/cmds/dmapi.git	v2.2.11-rc2
> git://oss.sgi.com/xfs/cmds/xfsdump.git	v3.1.1-rc2
> git://oss.sgi.com/xfs/cmds/xfsprogs.git	v3.1.9-rc2
> git://oss.sgi.com/xfs/cmds/xfstests.git	v1.2.0-rc2
>
> I believe many of the items on our list from -rc1 have been resolved.
>
> 1) xfsdump header checksum failures, fixed by b7af332.
> 2) futex hang in 059, still pending
> 3) the golden output changes related to multistream support in xfsdump
> and --largefs, fixed in the dump filter in Dave's --largefs patchset
> 4) test on more platforms
>
> AFAIK the futex hang has not been seen recently so we might not want to
> hold the release for that.  Maybe there are some stragglers on the
> mailing list to pull in.  If there are additional items for the todo
> list, speak up!  ;)
>
> Thanks,
> Ben
>


I would like to see Dave's latest test 242 and 290 output added:

  http://oss.sgi.com/archives/xfs/2012-11/msg00702.html

Thanks.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
