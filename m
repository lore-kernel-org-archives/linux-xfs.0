Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 620F37F3F
	for <xfs@oss.sgi.com>; Fri, 27 Dec 2013 01:41:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40658304064
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 23:41:13 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZKt1D4nQARNa9YBd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 23:41:12 -0800 (PST)
Message-ID: <52BD2F0F.3020907@oracle.com>
Date: Fri, 27 Dec 2013 15:41:03 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [xfs_check Out of memory: ]
References: <tencent_3F12563342ED1D4E049D1123@qq.com>
In-Reply-To: <tencent_3F12563342ED1D4E049D1123@qq.com>
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
To: Stor?? <289471341@qq.com>, xfs <xfs@oss.sgi.com>

On 12/27 2013 14:48 PM, Stor?? wrote:
> Hey:
> 
> 20T xfs file system
> 
>  
> 
> /usr/sbin/xfs_check: line 28: 14447 Killed                 
> xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
xfs_check is deprecated and please use xfs_repair -n instead.

The following back traces show us that it seems your system is run out memory
when executing xfs_check, thus, snmp daemon/xfs_db were killed.

Thanks,
-Jeff 
> 
> snmpd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
> 
> Pid: 4753, comm: snmpd Tainted: G          2.6.27.19-5-default #95
> 
>  
> 
> Call Trace:
> 
>  [<ffffffff8020d899>] show_trace_log_lvl+0x41/0x58
> 
>  [<ffffffff8020deff>] dump_stack+0x69/0x6f
> 
>  [<ffffffff8027fc54>] oom_kill_process+0x5c/0x1fe
> 
>  [<ffffffff8028023a>] out_of_memory+0x169/0x1ff
> 
>  [<ffffffff802831d0>] __alloc_pages_internal+0x2e4/0x3ce
> 
>  [<ffffffff8028504a>] __do_page_cache_readahead+0x79/0x183
> 
>  [<ffffffff8027f46a>] filemap_fault+0x15d/0x337
> 
>  [<ffffffff8028bae2>] __do_fault+0x52/0x37a
> 
>  [<ffffffff8028d765>] handle_mm_fault+0x382/0x75e
> 
>  [<ffffffff80482b1d>] do_page_fault+0x45a/0x81c
> 
>  [<ffffffff80480a99>] error_exit+0x0/0x51
> 
>  [<00007fccea2b1d00>] 0x7fccea2b1d00
> 
>  
> 
> Mem-Info:
> 
> Node 0 DMA per-cpu:
> 
> CPU    0: hi:    0, btch:   1 usd:   0
> 
> CPU    1: hi:    0, btch:   1 usd:   0
> 
> CPU    2: hi:    0, btch:   1 usd:   0
> 
> CPU    3: hi:    0, btch:   1 usd:   0
> 
> Node 0 DMA32 per-cpu:
> 
> CPU    0: hi:  186, btch:  31 usd: 160
> 
> CPU    1: hi:  186, btch:  31 usd: 173
> 
> CPU    2: hi:  186, btch:  31 usd:  50
> 
> CPU    3: hi:  186, btch:  31 usd: 176
> 
> Node 0 Normal per-cpu:
> 
> CPU    0: hi:  186, btch:  31 usd: 116
> 
> CPU    1: hi:  186, btch:  31 usd:  95
> 
> CPU    2: hi:  186, btch:  31 usd: 162
> 
> CPU    3: hi:  186, btch:  31 usd: 161
> 
> Active:3818904 inactive:3847 dirty:2 writeback:0 unstable:0
> 
>  free:19191 slab:25747 mapped:1530 pagetables:12518 bounce:0
> 
> Node 0 DMA free:7460kB min:4kB low:4kB high:4kB active:0kB inactive:0kB
> present:6160kB pages_scanned:0 all_unreclaimable? yes
> 
> lowmem_reserve[]: 0 2716 15820 15820
> 
> Node 0 DMA32 free:55240kB min:2760kB low:3448kB high:4140kB
> active:2386964kB inactive:4kB present:2782036kB pages_scanned:4026093
> all_unreclaimable? yes
> 
> lowmem_reserve[]: 0 0 13104 13104
> 
> Node 0 Normal free:14064kB min:13328kB low:16660kB high:19992kB
> active:12888652kB inactive:15384kB present:13418496kB
> pages_scanned:22792092 all_unreclaimable? yes
> 
> lowmem_reserve[]: 0 0 0 0
> 
> Node 0 DMA: 5*4kB 2*8kB 0*16kB 2*32kB 3*64kB 2*128kB 3*256kB 0*512kB
> 2*1024kB 0*2048kB 1*4096kB = 7460kB
> 
> Node 0 DMA32: 76*4kB 179*8kB 164*16kB 122*32kB 78*64kB 62*128kB 33*256kB
> 24*512kB 7*1024kB 1*2048kB 1*4096kB = 55240kB
> 
> Node 0 Normal: 192*4kB 58*8kB 12*16kB 3*32kB 0*64kB 0*128kB 1*256kB
> 0*512kB 0*1024kB 0*2048kB 3*4096kB = 14064kB
> 
> 5354 total pagecache pages
> 
> 0 pages in swap cache
> 
> Swap cache stats: add 0, delete 0, find 0/0
> 
> Free swap  = 0kB
> 
> Total swap = 0kB
> 
> 4161536 pages RAM
> 
> 139058 pages reserved
> 
> 24037 pages shared
> 
> 3992120 pages non-shared
> 
> Out of memory: kill process 14447 (xfs_db) score 670225 or a child
> 
> Killed process 14447 (xfs_db)
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
