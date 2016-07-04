Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 406C57CA2
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 17:52:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00B488F8035
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 15:52:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	a5MTzwuLDdWF8eiW for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2016 15:52:28 -0700 (PDT)
Date: Tue, 5 Jul 2016 08:52:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad Metadata performances for XFS?
Message-ID: <20160704225226.GD27480@dastard>
References: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
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
To: Wang Shilong <wshilong@ddn.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

[xfs@oss.sgi.com is where you'll find the XFS developers]

On Mon, Jul 04, 2016 at 05:32:40AM +0000, Wang Shilong wrote:
> Hello Guys,
> 
>       I happened run some benchmarks for XFS, and found some intresting to share here:
> Kernel version:
> [root@localhost shm]# uname -r
> 4.7.0-rc5+
> 
> [root@localhost shm]# cat /proc/cpuinfo  | grep Intel
> vendor_id	: GenuineIntel
> model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
> 
> dd 16GB to /dev/shm/data to use memory backend storage to benchmark metadata performaces.
> 
> Benchmark tool is mdtest, you can download it from 
> https://sourceforge.net/projects/mdtest/
> 
> Steps to run benchmark
> #mkfs.xfs /dev/shm/data
> #mount /dev/shm/data /mnt/test
> #mdtest -d /mnt/test -n 2000000
> 
> 1 tasks, 2000000 files/directories
> 
> SUMMARY: (of 1 iterations)
>    Operation                      Max            Min           Mean        Std Dev
>    ---------                      ---            ---           ----        -------
>    Directory creation:      24724.717      24724.717      24724.717          0.000
>    Directory stat    :    1156009.290    1156009.290    1156009.290          0.000
>    Directory removal :     103496.353     103496.353     103496.353          0.000
>    File creation     :      23094.444      23094.444      23094.444          0.000
>    File stat         :    1158704.969    1158704.969    1158704.969          0.000
>    File read         :     752731.595     752731.595     752731.595          0.000
>    File removal      :     105481.766     105481.766     105481.766          0.000
>    Tree creation     :       2229.827       2229.827       2229.827          0.000
>    Tree removal      :          1.275          1.275          1.275          0.000
> 
> -- finished at 07/04/2016 12:54:26 --
> 
> IOPS for file creation is only 2.3W, however compare to Ext4 with same testing.
>   Operation                      Max            Min           Mean        Std Dev
>    ---------                      ---            ---           ----        -------
>    Directory creation:      65875.462      65875.462      65875.462          0.000
>    Directory stat    :    1060115.356    1060115.356    1060115.356          0.000
>    Directory removal :     109955.606     109955.606     109955.606          0.000
>    File creation     :     114898.425     114898.425     114898.425          0.000
>    File stat         :    1046223.044    1046223.044    1046223.044          0.000
>    File read         :     699663.339     699663.339     699663.339          0.000
>    File removal      :     152320.304     152320.304     152320.304          0.000
>    Tree creation     :      19065.018      19065.018      19065.018          0.000
>    Tree removal      :          1.269          1.269          1.269          0.000
> 
> IOPS of file creation is more than 11W!!!
> 
> I understand Ext4 use Hash index tree and XFS use B+ tree for directroy, so i test Btrfs
> for this case.
>   ---------                      ---            ---           ----        -------
>    Directory creation:      99312.866      99312.866      99312.866          0.000
>    Directory stat    :    1116205.199    1116205.199    1116205.199          0.000
>    Directory removal :      66441.011      66441.011      66441.011          0.000
>    File creation     :      91282.930      91282.930      91282.930          0.000
>    File stat         :    1117636.580    1117636.580    1117636.580          0.000
>    File read         :     754964.332     754964.332     754964.332          0.000
>    File removal      :      69708.657      69708.657      69708.657          0.000
>    Tree creation     :      29746.837      29746.837      29746.837          0.000
>    Tree removal      :          1.289          1.289          1.289          0.000
> 
> Even Btrfs, it got about 9W....
> 
> Hmm..Maybe this is because too many files under single directory?(200W won't be too much i guess)
> I reduce number of files for XFS to 50W.
> 1 tasks, 500000 files/directories
> 
> SUMMARY: (of 1 iterations)
>    Operation                      Max            Min           Mean        Std Dev
>    ---------                      ---            ---           ----        -------
>    Directory creation:      53021.632      53021.632      53021.632          0.000
>    Directory stat    :    1187581.191    1187581.191    1187581.191          0.000
>    Directory removal :     108112.695     108112.695     108112.695          0.000
>    File creation     :      51654.911      51654.911      51654.911          0.000
>    File stat         :    1180447.310    1180447.310    1180447.310          0.000
>    File read         :     755391.001     755391.001     755391.001          0.000
>    File removal      :     108415.353     108415.353     108415.353          0.000
>    Tree creation     :       2129.088       2129.088       2129.088          0.000
>    Tree removal      :          5.272          5.272          5.272          0.000
> 
> -- finished at 07/04/2016 12:59:17 --
> 
> So performances go up from 2.3W to 5.1W, but still very slow compared to others...
> 
> 
> PS: mkfs options for Btrfs is: mkfs.btrfs -m single -d single -f
>        mkfs options for XFS is: mkfs.xfs -f
>        mkfs options for Ext4 is: mkfs.ext4 -i 2048(to generate enough inodes for testing)
> 
> Best Regards,
> Shilong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
