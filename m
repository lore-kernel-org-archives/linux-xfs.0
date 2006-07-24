Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 07:05:22 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6OE55DW005072
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 07:05:10 -0700
Received: from agami.com ([192.168.168.101])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k6OCefog006058
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 05:40:42 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k6OCeanY010312
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 05:40:36 -0700
Message-ID: <44C4BD30.2050507@agami.com>
Date: Mon, 24 Jul 2006 17:59:36 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Page allocation failure writing to an XFS volume via NFS on CentOS
 4.3
References: <68559cef0607210519q9f382c6n7104bef9cf9716f3@mail.gmail.com>	 <20060721161326.GE12347@tuatara.stupidest.org> <68559cef0607240449m5005231t78f05673bb8309e2@mail.gmail.com>
In-Reply-To: <68559cef0607240449m5005231t78f05673bb8309e2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Luca Maranzano <liuk001@gmail.com>
Cc: xfs@oss.sgi.com

Hi Luca,
         Almost all of your memory is being used for page cache which is 
good definitely for any I/O intensive applications. When you set 
min_free_kbytes to a very low number, it means that the pages used for 
various things (slab, cached pages) are not started to get cleaned up 
until it goes down to a very low level. So, it is true that memory 
allocation might fail if you set to to very low number

/proc/meminfo:
MemTotal:      1035832 kB
MemFree:         12568 kB
Buffers:         10468 kB
Cached:         968336 kB
SwapCached:       4716 kB

However, there is another culprit here. The memory cleaner code should 
typically avoid doing memory allocation in cleanup path; otherwise it 
may fail. dm_mod is splitting the bio and, hence, requires the page 
allocation which is definitely bad in such circumstances where memory is 
chewed up to the last pages. It so happened the bio_alloc pool was empty 
and required to be filled up.
For now, you should set min_free_kbytes to at least 8*1024 and 
preferably to [16-20] * 1024.
   As far as XFS memory messages are concerned, those message are 
indicating that the memory is either running low or so fragmented that 
the requested page order could not be allocated in reasonable time.

     kswapd0: page allocation failure. order:0, mode:0xd0
[<c014c48d>] __alloc_pages+0x2e1/0x2f7
[<c014c4bb>] __get_free_pages+0x18/0x24
[<c014f9a2>] kmem_getpages+0x15/0x94
[<c015065f>] cache_grow+0x107/0x233
[<c0150982>] cache_alloc_refill+0x1f7/0x227
[<c0150bf4>] kmem_cache_alloc+0x46/0x4c --> Memory allocation request 
for bio_alloc pool.
[<c014ac4d>] mempool_alloc+0xb6/0x1f9
[<c011e867>] autoremove_wake_function+0x0/0x2d
[<c011e867>] autoremove_wake_function+0x0/0x2d
[<f8aa86ea>] EmsPlatformCreateIo+0x2a/0x60 [emcp]
[<f8aa8978>] allocPio+0x18/0x40 [emcp]
[<f8aa89e7>] emcp_pseudo_mrf+0x27/0x60 [emcp]
[<c02518a6>] generic_make_request+0x190/0x1a0
[<c016dff5>] bio_clone+0x8b/0xa3
[<f8873370>] __map_bio+0x34/0xb4 [dm_mod]
[<f8873579>] __clone_and_map+0xc3/0x2c9 [dm_mod]
[<c014c35d>] __alloc_pages+0x1b1/0x2f7
[<f8873829>] __split_bio+0xaa/0x108 [dm_mod]
[<f8873965>] dm_request+0xde/0xf1 [dm_mod]
[<c02518a6>] generic_make_request+0x190/0x1a0
[<c011e867>] autoremove_wake_function+0x0/0x2d
[<c025195a>] submit_bio+0xa4/0xac
[<c016de25>] bio_alloc+0x100/0x168
[<c016d7da>] submit_bh+0x13e/0x163
[<f93a4d6d>] xfs_submit_page+0x84/0xa8 [xfs]
[<f93a4f71>] xfs_convert_page+0x1e0/0x1f4 [xfs]
[<f93a4fbe>] xfs_cluster_write+0x39/0x43 [xfs]
[<f93a5488>] xfs_page_state_convert+0x4c0/0x50c [xfs]
[<f93a598a>] linvfs_writepage+0x91/0xc6 [xfs]
[<c0152fac>] pageout+0x88/0xc5
[<c01531f2>] shrink_list+0x209/0x4ea
[<c01536d2>] shrink_cache+0x1ff/0x454
[<c0152d91>] shrink_slab+0x7d/0x14c
[<c015408c>] shrink_zone+0x8f/0x9e
[<c015442f>] balance_pgdat+0x197/0x2cb  --> Cleaner code


Regards,
Shailendra

Luca Maranzano wrote:
> Could it be an issue about the min_free_kbytes kernel parameter?
> 
> On my server its current value is 957, but I've read that this could
> lead to kernel memory allocation failure even if there is actually
> enough RAM available.
> 
> Since my trouble seem to be correlated to NFS access, could it be an
> interaction between network and disk I/O to trigger this problem?
> 
> Thanks again.
> Regards,
> Luca
> 
> 
> On 7/21/06, Chris Wedgwood <cw@f00f.org> wrote:
> 
>> On Fri, Jul 21, 2006 at 02:19:34PM +0200, Luca Maranzano wrote:
>>
>> > kswapd0: page allocation failure. order:0, mode:0xd0
>>
>> you're out of memory, see what's being so piggy
>>
> 
> 
