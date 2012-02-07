Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q171MPB8181090 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 19:22:25 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id tlHikHa4o9dyKCtO for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 17:22:23 -0800 (PST)
Message-ID: <4F307C94.2020004@cn.fujitsu.com>
Date: Tue, 07 Feb 2012 09:21:24 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: add btrfs online defragments QA test
References: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
	<1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com>
	<20120206121155.GA16044@infradead.org>
In-Reply-To: <20120206121155.GA16044@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 02/06/2012 08:11 PM, Christoph Hellwig wrote:
> On Mon, Feb 06, 2012 at 04:27:49PM +0800, Liu Bo wrote:
>> +_runtest()
>> +{
>> +	$progs_dir/runtest.sh $defrag_args $SCRATCH_MNT $SCRATCH_DEV
> 
> please put the actual tests into test cases themselves instead of
> calling out into shell scripts under src.  If you have common code
> shared between multiple tests please put them into common.defrag.
> 

I see, will update it.

>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +. ./common.defrag
>> +
>> +# real QA test starts here
>> +_supported_fs xfs btrfs
> 
> does it really support xfs?
> 

sorry, my miss.

Thanks for reviewing!

thanks,
liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
