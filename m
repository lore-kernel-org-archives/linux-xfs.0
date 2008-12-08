Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB84qF3b032677 for <xfs@oss.sgi.com>; Sun, 7 Dec 2008 22:52:15 -0600
Message-ID: <493CA7F8.9070305@sgi.com>
Date: Mon, 08 Dec 2008 15:52:08 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: xfstests/192 atime test
References: <49192204.3040300@sgi.com> <20081111223810.GK2373@disturbed>
	<491A13CA.6010404@sgi.com> <491A1709.9020705@sgi.com>
In-Reply-To: <491A1709.9020705@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Timothy Shimmin wrote:
>> Dave Chinner wrote:
>>> On Tue, Nov 11, 2008 at 05:11:16PM +1100, Timothy Shimmin wrote:
>>>> Attached simple atime test.
>>>> 192.out and group file would be added appropriately.
>>>> Thanks.
>>>> --Tim
>>>> _supported_fs xfs udf nfs
>>>> _supported_os Linux
>>>> delay=150
>>> 150s sleep? It only needs a few seconds for this test.
>>>
>> Not for me. Passed every time at a few secs,
>> that is why I tried longer as was originally reported.
>>
>>>> time3=`_access_time $testfile | tee -a $seq.full`
>>>>
>>>> delta1=`expr $time2 - $time1`
>>>> delta2=`expr $time3 - $time1`
>>>>
>>>> echo "delta1 - access time after sleep in-core: $delta1"
>>>> echo "delta2 - access time after sleep on-disk: $delta2"
>>> Why bother with deltas? if the numbers are the same, just output
>>> "same", if they are different, output "different"....
>>>
>> Fine, will do.
>>
> The only other thing is that I am not just testing the bug
> as it stands - i.e. if the atime is being lost on-disk.
> I want to test that the atime is updated appropriately.
> 
> --Tim
> 

Ping?
Not fussed?

Thanks,
--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
