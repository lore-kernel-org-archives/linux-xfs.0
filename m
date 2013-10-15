Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB32C7F50
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:13:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C82BA8F806F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 11:13:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SFOrFWA0HYnC5OuU for
	<xfs@oss.sgi.com>; Tue, 15 Oct 2013 11:13:16 -0700 (PDT)
Message-ID: <525D85B8.5040504@redhat.com>
Date: Tue, 15 Oct 2013 13:13:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: reject completely bogus remount options
References: <52584C8A.1060808@redhat.com> <52584D56.7090902@sandeen.net>
	<20131013215208.GE5663@dastard> <525B5A1D.90706@sandeen.net>
	<20131014044501.GE4446@dastard>
In-Reply-To: <20131014044501.GE4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 10/13/13 11:45 PM, Dave Chinner wrote:
> On Sun, Oct 13, 2013 at 09:42:37PM -0500, Eric Sandeen wrote:
>> On 10/13/13 4:52 PM, Dave Chinner wrote:
>>> On Fri, Oct 11, 2013 at 02:11:18PM -0500, Eric Sandeen wrote:
>>>> There's a long comment about handling non-remountable
>>>> options in xfs_fs_remount, but nothing addresses the case
>>>> of completely bogus mount options at remount time, which
>>>> can lead to some severe strangeness:
>>>>
>>>> # for I in `seq 1 10`; do mount -o remount,noacl /mnt/test2; done
>>>> # for I in `seq 1 10`; do mount -o remount,badoption /mnt/test2; done

I'm going to just drop this patch for now; it seems too hacky.

really, mount option handling just needs a big rework.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
