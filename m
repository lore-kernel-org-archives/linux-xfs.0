Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84E9DD5104946 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 09:09:13 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bTHBCITQtHyKnmUr for
	<xfs@oss.sgi.com>; Tue, 04 Sep 2012 07:10:11 -0700 (PDT)
Message-ID: <50460BF1.3070100@redhat.com>
Date: Tue, 04 Sep 2012 10:10:57 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 4/4] xfs: add background scanning to clear EOFBLOCKS
	inodes
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-5-git-send-email-bfoster@redhat.com>
	<20120903052842.GT15292@dastard>
In-Reply-To: <20120903052842.GT15292@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/03/2012 01:28 AM, Dave Chinner wrote:
> On Mon, Aug 27, 2012 at 03:51:51PM -0400, Brian Foster wrote:
>> Create a delayed_work to enable background scanning and freeing
>> of EOFBLOCKS inodes. The scanner kicks in once speculative
>> preallocation occurs and stops requeueing itself when no EOFBLOCKS
>> inodes exist.
>>
>> Scans are queued on the existing syncd workqueue and the interval
>> is tied to the syncd interval, which is a default of 30s. The
>> minimum file size for a background scan is hardcoded to 100MB.
> 
> I'd set it to be much longer than the xfs_syncd_centisecs period.
> The data may not be written back for a long while, and a file that
> is open, written and closed repeatedly (NFS write patterns for large
> and/or slowly written files) should not have it's preallocation
> truncated every 30s.
> 
> I'd suggest that a 5 minute sweep is probably sufficiently frequent
> to avoid most fragmentation issues and long term buildup of speculative
> preallocation whilst not perturbing large/slow writers too much....
> 

Any thoughts on having tunables for both values (time and min size?) on
the background scanning?

> Apart from that, there isn't anything wrong with the code, except
> I'll note again that it conflicts with my syncd removal patchset....
> 

Yeah, I skimmed through those patches and noticed it would shuffle this
code around. Thanks for pointing it out. I'll keep an eye on that set.

Thanks for the review. I'll follow up with a patchset that incorporates
the feedback.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
