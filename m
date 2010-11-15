Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFLTR9w178973 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 15:29:27 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AFAD7AC008
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 13:30:56 -0800 (PST)
Message-ID: <4CE1A690.8020007@sgi.com>
Date: Mon, 15 Nov 2010 15:30:56 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 6/9] xfsrestore: fix node table setup
References: <20101105163500.747192954@sgi.com>	
	<20101105163644.182690256@sgi.com>
	<1289853515.2199.225.camel@doink>
In-Reply-To: <1289853515.2199.225.camel@doink>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 11/15/2010 02:38 PM, Alex Elder wrote:
> On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
>> plain text document attachment (winmap_max_fix)
>> The node table setup code unintentionally limits the amount of virtual
>> memory that will be used for the node table. Rather than setting a
>> limit based on the remaining virtual memory, the node table is limited
>> to the amount of memory it thinks it will need based on the dump's
>> inode count. But the node table stores directory entries, not inodes,
>> and so dumps with lots of hard links end up thrashing mapping and
>> unmapping segments of the node table to stay within the self-imposed
>> virtual memory limit.
>>
>> This patch also changes the node table to ensure that there are a
>> power of two nodes per segment. Profiling revealed that while building
>> the node table, 50% of the restore cpu time was spent doing division
>> and modulo to convert a node index into its segment index and offset
>> within the segment. This change prepares the node table for another
>> patch which will change the lookup mechanism to use shift and
>> bitwise-and.
>>
>> Also don't bother passing the estimated segment table size to the
>> window abstraction. It has to deal with resizing the table anyway and
>> can choose a reasonable starting size.
>>
>>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>
> This looks good to me.
>
> In your loop determining how many segments to
> use, etc., you might as well start with the
> minimum number of segments.  I.e.:
>
> winmapmax = 0;
> for ( segcount = WINMAP_MIN; winmapmax<  WINMAP_MIN; segcount<<= 1 ) {
>
> I had a feeling there could be a pathological case
> in which the the computation of winmapmax, etc. would
> get stuck looping indefinitely, but I gave up trying
> to see if I could identify such a case...

I had a similar thought while making the change, but then
remembered that we just need enough virtual memory to
map up to WINMAP_WIN segments. It's perfectly okay to
only use one segment assuming there's enough virtual
memory.

I did some unit testing here playing around with the
bounds of the inputs (inode count and virtual memory size)
just to be sure that all output params were sane.

Bill

>
> And although I'm not that confident I understand the way
> the windows on the tree file are used, I don't see anything
> really wrong with your change.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
