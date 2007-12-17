Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 14:18:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBHMIa0n020501
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:18:38 -0800
Received: from sargon.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3935B492F32
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:18:37 -0800 (PST)
Received: from sargon.lncsa.com (sargon-nerim.lncsa.com [195.5.245.101]) by cuda.sgi.com with ESMTP id mss5mfl6AjXiIgoe for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:18:37 -0800 (PST)
Message-ID: <4766F58C.8040000@lncsa.com>
Date: Mon, 17 Dec 2007 23:17:48 +0100
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Re: Issue with 2.6.23 and drbd 8.0.7
References: <20071217143655.chiehahh@trusted.lncsa.com> <20071217220354.GU4396912@sgi.com>
In-Reply-To: <20071217220354.GU4396912@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------070007060605030807030603"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070007060605030807030603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

David Chinner wrote:
> The symptoms you see are the machine running out of memory and the OOM
> killer being invoked. There's nothing XFS here - you'd do better to post
> to lkml about this.

So, I was wrong .... :$

> Hmmm - you appear to have a highmem based box and have run out of
> low memory for the kernel. So while having ~9.5GB of free high
> memory (that the kernel can't directly use), you're out of low
> memory that the kernel can use and hence it is going OOM.  The
> output of /proc/slabinfo or watching slabtop will tell you where
> most of this memory is going.

Please find attached the output from /proc/slabinfo from both servers,
as well as output from slabtop from server 1.

> 
> FWIW, I suggest upgrading to a 64 bit machine ;)

I'm currently migrating those 2 servers to 2 64 Bit setups ;)

Thanks for your advice.

Laurent

--------------070007060605030807030603
Content-Type: text/plain;
 name="slabinfo-srv1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slabinfo-srv1"

slabinfo - version: 2.1 (statistics)
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail> : globalstat <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow> : cpustat <allochit> <allocmiss> <freehit> <freemiss>
nfs_direct_cache       0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfs_write_data        36     40    480    8    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat      40     40     5    0 				   0    0    0    0    0 : cpustat     31      5      0      0
nfs_read_data         32     32    456    8    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat      32     32     4    0 				   0    0    0    0    0 : cpustat     28      4      0      0
nfs_inode_cache        0      0    640    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfs_page               0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_delegations      0      0    240   16    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_stateids         0      0     96   40    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_files            0      0     64   59    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_stateowners      0      0    368   10    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
rpc_buffers            8      9   2072    3    2 : tunables   24   12    8 : slabdata      3      3      0 : globalstat      15     15     5    2 				   0    0    0    0    0 : cpustat     21      5     18      0
rpc_tasks              8     19    200   19    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      73     73     4    3 				   0    0    0    0    0 : cpustat     19      7     18      0
rpc_inode_cache        6      8    488    8    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       8      8     1    0 				   0    0    0    0    0 : cpustat      5      1      0      0
fib6_nodes            13     67     56   67    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      64     50     1    0 				   0    0    0    0    0 : cpustat      9      4      0      0
ip6_dst_cache         16     45    256   15    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat      72     45     3    0 				   0    0    0    0    0 : cpustat     34      7     25      0
ndisc_cache            1     20    192   20    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      43     36     2    1 				   0    0    0    0    0 : cpustat      7      4     10      0
RAWv6                 11     12    672    6    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      12     12     2    0 				   0    0    0    0    0 : cpustat      9      2      0      0
UDPLITEv6              0      0    656    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
UDPv6                  9     24    656    6    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat   82827     54  1316 1312 				   0    0    0    0    0 : cpustat   1361   6800   8152      0
tw_sock_TCPv6          2     26    152   26    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat   38475     68   640  639 				   0    0    0    0    0 : cpustat    186   2672   2856      0
request_sock_TCPv6      0      0    136   29    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
TCPv6                 29     51   1328    3    1 : tunables   24   12    8 : slabdata     17     17      0 : globalstat  132027    369   853  836 				   0    0    0    0    0 : cpustat   3762  14150  17883      0
ip_fib_alias          73    156     48   78    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat     510    155     2    0 				   0    0    0    0    0 : cpustat    105     32     64      0
ip_fib_hash           73    156     48   78    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat     510    155     2    0 				   0    0    0    0    0 : cpustat    102     32     61      0
dm_snap_pending_exception    128    132     88   44    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat     132    132     3    0 				   0    0    0    0    0 : cpustat    119      9      0      0
dm_snap_exception      0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_target_io           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_io                  0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nf_conntrack_expect      0      0    184   21    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nf_conntrack        1288   1830    264   15    1 : tunables   32   16    8 : slabdata    122    122      0 : globalstat  695930   4560   861    9 				   0    0    0    0    0 : cpustat 2115732  47751 2145280  16976
drbd_ee_cache        268    396     88   44    1 : tunables   32   16    8 : slabdata      9      9      0 : globalstat 1355529   1496  8406 2718 				   0    3    0    0    0 : cpustat 5275151 190574 5286409 179060
drbd_req_cache       289    396     88   44    1 : tunables   32   16    8 : slabdata      8      9      0 : globalstat 2487110   6220 12750 2527 				   0    3    0    0    0 : cpustat 9536991 411417 9608406 339745
raid5-md3            256    256   1000    4    1 : tunables   32   16    8 : slabdata     64     64      0 : globalstat     256    256    64    0 				   0    0    0    0    0 : cpustat    192     64      0      0
raid5-md2            256    256   1000    4    1 : tunables   32   16    8 : slabdata     64     64      0 : globalstat     256    256    64    0 				   0    0    0    0    0 : cpustat    192     64      0      0
raid5-md1            256    256   1000    4    1 : tunables   32   16    8 : slabdata     64     64      0 : globalstat     256    256    64    0 				   0    0    0    0    0 : cpustat    192     64      0      0
sgpool-128             2      3   2584    3    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       3      3     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-64              2      3   1304    3    1 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       3      3     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-32              2      6    664    6    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       6      6     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-16              2     11    344   11    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      11     11     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-8               2     21    184   21    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
scsi_io_context        0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
uhci_urb_priv          4    134     56   67    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      84     83     2    0 				   0    0    0    0    0 : cpustat     56      6     58      0
UNIX                 704    960    456    8    1 : tunables   32   16    8 : slabdata    120    120      0 : globalstat  913635   2152   742  220 				   0    1    0    0    0 : cpustat 1084624  58989 1141401   1541
flow_cache         13077  13098    104   37    1 : tunables   32   16    8 : slabdata    354    354      0 : globalstat 9455477  32412 125847    0 				   0    0    0    0    0 : cpustat 8935534 693254 9018654 597113
cfq_io_context       557   2205    112   35    1 : tunables   32   16    8 : slabdata     63     63      0 : globalstat  317617   2361    72    5 				   0    0    0    0    0 : cpustat  27777  19956  47146     30
cfq_queue            564   2170    112   35    1 : tunables   32   16    8 : slabdata     62     62      0 : globalstat  317788   2361    77   10 				   0    0    0    0    0 : cpustat  27668  19960  47035     29
mqueue_inode_cache      1      7    536    7    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       7      7     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
xfs_chashlist      30513  34866     48   78    1 : tunables   32   16    8 : slabdata    447    447      0 : globalstat  647346  34836   447    0 				   0    0    0    0    0 : cpustat 528235  59293 528202  28813
xfs_ili             5374   8326    168   23    1 : tunables   32   16    8 : slabdata    362    362      0 : globalstat  808969  36862  2118   61 				   0    2    0    0    0 : cpustat 226653  56049 269154   8202
xfs_inode         227129 245574    408    9    1 : tunables   32   16    8 : slabdata  27286  27286      0 : globalstat 9651465 385191 557966  350 				   0   16    0    0    0 : cpustat 9202077 908677 9281594 602076
xfs_efi_item          12     13    288   13    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat  440732    221 14394 14387 				   0    2    0    0    0 : cpustat 127853  34809 162040    621
xfs_efd_item          12     13    288   13    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat  440681    221 14383 14375 				   0    2    0    0    0 : cpustat 127856  34806 162042    619
xfs_buf_item          99    198    176   22    1 : tunables   32   16    8 : slabdata      8      9      0 : globalstat  888702    682  2486 2269 				   0    1    0    0    0 : cpustat 3904057  65575 3959515  10057
fstrm_item             0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfs_mru_cache_elem      0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfs_acl                0      0    328   12    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     816     96    68   68 				   0    0    0    0    0 : cpustat 9610430     68 9610498      0
xfs_ifork              0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfs_dabuf             66    184     40   92    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  664615    169   638  636 				   0    0    0    0    0 : cpustat 39276426  42121 39318508     39
xfs_da_state          20     22    360   11    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  305744    143 12529 12527 				   0    0    0    0    0 : cpustat 7610566  26375 7636932      9
xfs_trans             38     72    656    6    1 : tunables   32   16    8 : slabdata      9     12      0 : globalstat  953186    462 28482 28298 				   0   23    0    0    0 : cpustat 2929804 160990 3007558  83228
xfs_btree_cur         46     46    168   23    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  683790    131  4408 4406 				   0    0    0    0    0 : cpustat 2107846  47358 2155204      0
xfs_bmap_free_item     18     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat  495962    131  3136 3135 				   0    0    0    0    0 : cpustat 137319  31479 168798      0
xfs_buf              164    288    216   18    1 : tunables   32   16    8 : slabdata     16     16      0 : globalstat 1015193    772  1287  890 				   0    3    0    0    0 : cpustat 69896276  93787 69956038  33936
xfs_ioend             92    144     80   48    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat  907532    784  6446 6219 				   0    2    0    0    0 : cpustat 585485  63935 642272   7116
xfs_vnode         227106 243130    392   10    1 : tunables   32   16    8 : slabdata  24313  24313      0 : globalstat 9547711 385180 500984  462 				   0   15    0    0    0 : cpustat 9540232 842184 9557063 598278
ext2_inode_cache       0      0    496    8    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext2_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
journal_handle         0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
journal_head           0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
revoke_table           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
revoke_record          0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext3_inode_cache       0      0    512    8    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext3_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dnotify_cache          1     78     48   78    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
dquot                  0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_event_cache      0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_watch_cache      1     59     64   59    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     16     2    1 				   0    0    0    0    0 : cpustat      0      2      1      0
kioctx                 0      0    208   19    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
kiocb                  0      0    160   24    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fasync_cache           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     192     17    11   11 				   0    0    0    0    0 : cpustat      0     12     12      0
shmem_inode_cache    527    608    464    8    1 : tunables   32   16    8 : slabdata     76     76      0 : globalstat  104470    624    92   16 				   0    0    0    0    0 : cpustat  10086   6615  16172      2
nsproxy                0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
posix_timers_cache      0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
uid_cache             35    288     80   48    1 : tunables   32   16    8 : slabdata      6      6      0 : globalstat  250407    312    51   45 				   0    0    0    0    0 : cpustat   5996  15733  21694      0
ip_mrt_cache           0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
UDP-Lite               0      0    544    7    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
tcp_bind_bucket      175    644     40   92    1 : tunables   32   16    8 : slabdata      7      7      0 : globalstat  751772    614     8    0 				   0    0    0    0    0 : cpustat 195022  48536 241640   1775
inet_peer_cache       43    106     72   53    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat   21717    103     2    0 				   0    0    0    0    0 : cpustat    114   1358   1429      0
secpath_cache        135    201     56   67    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat  227178    332    22   18 				   0    0    0    0    0 : cpustat 12014865  46791 12023500  38156
xfrm_dst_cache       125    624    288   13    1 : tunables   32   16    8 : slabdata     48     48      0 : globalstat  541378   1118  1988    2 				   0    0    0    0    0 : cpustat  62275  36074  92381   5845
ip_dst_cache        1342   2220    264   15    1 : tunables   32   16    8 : slabdata    148    148      0 : globalstat 1146538   4050  1768    0 				   0    0    0    0    0 : cpustat 422000  77235 469442  28528
arp_cache             42    147    184   21    1 : tunables   32   16    8 : slabdata      7      7      0 : globalstat   85935    310    31   24 				   0    0    0    0    0 : cpustat    813   5417   6187      1
RAW                   10     14    528    7    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat   20766     63   787  785 				   0    0    0    0    0 : cpustat   3801   3688   7479      0
UDP                   75     91    544    7    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat  568918    147  9149 9136 				   0    0    0    0    0 : cpustat 213130  47456 260529      0
tw_sock_TCP           76    192    120   32    1 : tunables   32   16    8 : slabdata      6      6      0 : globalstat  801606    800   369  182 				   0    0    0    0    0 : cpustat 192527  54470 242102   4835
request_sock_TCP      27    120     96   40    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat  773451    240   686  682 				   0    0    0    0    0 : cpustat 526932  52326 575461   3788
TCP                  199    207   1216    3    1 : tunables   24   12    8 : slabdata     69     69      0 : globalstat  584635    354 12556 12487 				   0    2    0    0    0 : cpustat 717628  63427 779057   1837
eventpoll_pwq        356    649     64   59    1 : tunables   32   16    8 : slabdata     11     11      0 : globalstat  723696    665    14    0 				   0    0    0    0    0 : cpustat 991533  45447 1036379    296
eventpoll_epi        356    640     96   40    1 : tunables   32   16    8 : slabdata     16     16      0 : globalstat  723672    672    20    1 				   0    0    0    0    0 : cpustat 991529  45451 1036378    297
blkdev_ioc            96    469     56   67    1 : tunables   32   16    8 : slabdata      7      7      0 : globalstat  169619    449     9    2 				   0    0    0    0    0 : cpustat   5658  10614  16175      1
blkdev_queue          31     48   1008    4    1 : tunables   32   16    8 : slabdata     12     12      0 : globalstat      71     48    12    0 				   0    0    0    0    0 : cpustat     17     14      0      0
blkdev_requests      333    720    216   18    1 : tunables   32   16    8 : slabdata     40     40    128 : globalstat 4195813   1186  9623  168 				   0    1    0    0    0 : cpustat 53673071 1459720 53709489 1423266
biovec-256             2      2   3096    2    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       2      2     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
biovec-128             2      5   1560    5    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat     652    205   125  111 				   0    2    0    0    0 : cpustat    788    155    889     52
biovec-64             64    100    792    5    1 : tunables   32   16    8 : slabdata     18     20      0 : globalstat  848803    620 62220 60744 				   0   19    0    0    0 : cpustat 663524 110913 762385  12050
biovec-16              5     54    216   18    1 : tunables   32   16    8 : slabdata      2      3      0 : globalstat  897258    268  6926 6885 				   0    3    0    0    0 : cpustat 730705  69353 793279   6777
biovec-4              28    212     72   53    1 : tunables   32   16    8 : slabdata      3      4      0 : globalstat 1174720    509  2204 1980 				   0    2    0    0    0 : cpustat 2790389 103804 2863441  30750
biovec-1             265    644     40   92    1 : tunables   32   16    8 : slabdata      7      7    112 : globalstat 10001880  11304  7253    6 				   0    1    0    0    0 : cpustat 51100091 1714212 51139147 1675154
bio                  284    600     96   40    1 : tunables   32   16    8 : slabdata     15     15    128 : globalstat 10331188  11280 31364   40 				   0    2    0    0    0 : cpustat 55439258 1844668 55488594 1795330
sock_inode_cache     983   1620    400   10    1 : tunables   32   16    8 : slabdata    162    162      0 : globalstat  735730   2410   334   13 				   0    1    0    0    0 : cpustat 2291435  52679 2335528   7664
skbuff_fclone_cache     94    170    392   10    1 : tunables   32   16    8 : slabdata     17     17      0 : globalstat  651571   1330  6042 4947 				   0    7    0    0    0 : cpustat 13744931 286325 13777035 254216
skbuff_head_cache   1418   2508    208   19    1 : tunables   32   16    8 : slabdata    132    132      0 : globalstat  563749   5244   420    0 				   0    5    0    0    0 : cpustat 147443205 630425 147454152 618190
file_lock_cache       92    224    120   32    1 : tunables   32   16    8 : slabdata      7      7      0 : globalstat  894359    282    20   12 				   0    0    0    0    0 : cpustat 3175262  55912 3231123      3
Acpi-Operand         561    590     64   59    1 : tunables   32   16    8 : slabdata     10     10      0 : globalstat     598    575    10    0 				   0    0    0    0    0 : cpustat   1786     51   1266     10
Acpi-ParseExt          0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     154    106     4    2 				   0    0    0    0    0 : cpustat   1902     19   1909     12
Acpi-Parse             0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      96     48     3    2 				   0    0    0    0    0 : cpustat   2647      6   2653      0
Acpi-State             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     112     48     2    1 				   0    0    0    0    0 : cpustat   4618      7   4625      0
Acpi-Namespace       422    468     48   78    1 : tunables   32   16    8 : slabdata      6      6      0 : globalstat     422    422     6    0 				   0    0    0    0    0 : cpustat    395     27      0      0
proc_inode_cache    1520   1690    376   10    1 : tunables   32   16    8 : slabdata    169    169      0 : globalstat  714611   6580  3518  322 				   0    7    0    0    0 : cpustat 494362  47218 537206   2860
sigqueue              51    115    168   23    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat  629811    177   663  658 				   0    3    0    0    0 : cpustat 2916985 143505 2952852 107636
radix_tree_node    88310  88356    312   12    1 : tunables   32   16    8 : slabdata   7363   7363      0 : globalstat  745753 115164 12973  292 				   0    7    0    0    0 : cpustat 519110  61596 469468  22958
bdev_cache            50     72    472    8    1 : tunables   32   16    8 : slabdata      9      9      0 : globalstat     233     72     9    0 				   0    0    0    0    0 : cpustat    123     20     93      0
sysfs_dir_cache     8403   8448     80   48    1 : tunables   32   16    8 : slabdata    176    176      0 : globalstat    8724   8432   176    0 				   0    0    0    0    0 : cpustat   8238    550    385      0
mnt_cache             28     87    136   29    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat     293     87     3    0 				   0    0    0    0    0 : cpustat     20     19     11      0
inode_cache          104    297    360   11    1 : tunables   32   16    8 : slabdata     27     27      0 : globalstat  658638   2101   379  179 				   0   12    0    0    0 : cpustat 470365  41758 511518    517
dentry            170738 215280    160   24    1 : tunables   32   16    8 : slabdata   8970   8970      0 : globalstat 10244796 397216 102210   72 				   0    6    0    0    0 : cpustat 13480269 753982 13406540 657036
filp                4912  10632    160   24    1 : tunables   32   16    8 : slabdata    443    443      0 : globalstat 5370475  16192  4793   20 				   0    6    0    0    0 : cpustat 21789897 711901 21835962 660983
names_cache           56     67   4096    1    1 : tunables   24   12    8 : slabdata     56     67      0 : globalstat  256326    125 60543 60472 				   0   28    0    0    0 : cpustat 78886148  93687 78970917   8918
key_jar               70    315    112   35    1 : tunables   32   16    8 : slabdata      9      9      0 : globalstat  257958    522   197  183 				   0    0    0    0    0 : cpustat  27040  16418  43385      3
idr_layer_cache       87    120    160   24    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat     904    136     6    1 				   0    0    0    0    0 : cpustat    209     59    181      0
buffer_head       150095 460752     80   48    1 : tunables   32   16    8 : slabdata   9599   9599      0 : globalstat 3166476 717184 29407  408 				   0    3    0    0    0 : cpustat 3275490 235016 3179139 181289
mm_struct            273    456    456    8    1 : tunables   32   16    8 : slabdata     57     57      0 : globalstat  730938   1016   497  325 				   0    1    0    0    0 : cpustat 1070644  47156 1116501   1050
vm_area_struct     12043  23870    112   35    1 : tunables   32   16    8 : slabdata    682    682     32 : globalstat 4061270  30972  1290   12 				   0    3    0    0    0 : cpustat 36608058 1142756 36652110 1086726
fs_cache             278   1003     64   59    1 : tunables   32   16    8 : slabdata     17     17      0 : globalstat  712761   1048    18    0 				   0    0    0    0    0 : cpustat 554624  45781 598721   1421
files_cache          271    658    280   14    1 : tunables   32   16    8 : slabdata     47     47      0 : globalstat  728709   1036   130   40 				   0    0    0    0    0 : cpustat 553483  46923 598617   1533
signal_cache         400    656    472    8    1 : tunables   32   16    8 : slabdata     82     82      0 : globalstat  703490   1168   621  433 				   0    1    0    0    0 : cpustat 555193  46478 599135   2151
sighand_cache        396    453   1328    3    1 : tunables   24   12    8 : slabdata    151    151      0 : globalstat  530997   1131  6172 5791 				   0    2    0    0    0 : cpustat 547368  53414 596995   3402
task_struct          482    609   1360    3    1 : tunables   24   12    8 : slabdata    203    203      0 : globalstat  585000   1212  5141 4598 				   0    3    0    0    0 : cpustat 583033  57116 635803   3886
anon_vma            4322  12696     40   92    1 : tunables   32   16    8 : slabdata    138    138      0 : globalstat 1454428  15154   173    0 				   0    0    0    0    0 : cpustat 6520030 177187 6588308 104622
pmd                  759    803   4096    1    1 : tunables   24   12    8 : slabdata    759    803      0 : globalstat  647373   2793 192109 186598 				   0   97    0    0    0 : cpustat 3095992 257408 3329432  23221
pid                  485   1180     64   59    1 : tunables   32   16    8 : slabdata     20     20      0 : globalstat  763758   1239    24    2 				   0    0    0    0    0 : cpustat 590266  49876 637212   2475
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072            1      1 131072    1   32 : tunables    8    4    0 : slabdata      1      1      0 : globalstat       3      2     3    2 				   0    0    0    0    0 : cpustat      0      3      2      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-65536             2      2  65536    1   16 : tunables    8    4    0 : slabdata      2      2      0 : globalstat       4      4     4    2 				   0    0    0    0    0 : cpustat      0      4      2      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       1      1     1    1 				   0    0    0    0    0 : cpustat      2      1      3      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-16384           262    293  16384    1    4 : tunables    8    4    0 : slabdata    262    293      0 : globalstat 4330681    360 45780 10057 				   0   33    0    0    0 : cpustat 3531416 1121179 3615531 1036807
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-8192             20     20   8192    1    2 : tunables    8    4    0 : slabdata     20     20      0 : globalstat 1572829     88 27111 24934 				   0   33    0    0    0 : cpustat 1399242 415275 1445755 368742
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4096            245    283   4096    1    1 : tunables   24   12    8 : slabdata    245    283     12 : globalstat  516834    502 112610 112112 				   0   97    0    0    0 : cpustat 13810582 211281 13957057  64627
size-2048(DMA)         0      0   2072    3    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2048           1340   1383   2072    3    2 : tunables   24   12    8 : slabdata    461    461     12 : globalstat  479384   2700  7828 1112 				   0   33    0    0    0 : cpustat 50927863 443555 50943192 427000
size-1024(DMA)         0      0   1048    7    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1024            893    973   1048    7    2 : tunables   24   12    8 : slabdata    139    139      0 : globalstat  420740   1120   314  107 				   0    1    0    0    0 : cpustat 19662753 343204 19681013 324148
size-512(DMA)          0      0    536    7    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-512            1930   2002    536    7    1 : tunables   32   16    8 : slabdata    286    286      0 : globalstat  424825   2156   699  264 				   0    3    0    0    0 : cpustat 24256290 320736 24265425 309784
size-256(DMA)          0      0    280   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-256             682    742    280   14    1 : tunables   32   16    8 : slabdata     53     53      0 : globalstat  731808    938  1202 1045 				   0    1    0    0    0 : cpustat 1168117  50670 1213652   4496
size-192(DMA)          0      0    216   18    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-192            2126   2682    216   18    1 : tunables   32   16    8 : slabdata    149    149      0 : globalstat  710574   2734   214   59 				   0    0    0    0    0 : cpustat 11225961  44924 11268431    373
size-128(DMA)          0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-128           14464  40456    152   26    1 : tunables   32   16    8 : slabdata   1556   1556      0 : globalstat 4771872 212748 120992   50 				   0    5    0    0    0 : cpustat 4580606 366443 4632729 299856
size-64(DMA)           0      0     88   44    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32(DMA)           0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-64            27959  30492     88   44    1 : tunables   32   16    8 : slabdata    693    693      2 : globalstat  887144 145068  4332   11 				   0    1    0    0    0 : cpustat 18149938  65422 18136641  50921
size-32             7888  10653     56   67    1 : tunables   32   16    8 : slabdata    159    159      6 : globalstat  963408  10653   161    1 				   0    1    0    0    0 : cpustat 6505589  83592 6552327  29008
kmem_cache           178    195    256   15    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat     322    195    13    0 				   0    0    0    0    0 : cpustat    119     59      0      0

--------------070007060605030807030603
Content-Type: text/plain;
 name="slabinfo-srv2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slabinfo-srv2"

slabinfo - version: 2.1 (statistics)
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail> : globalstat <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow> : cpustat <allochit> <allocmiss> <freehit> <freemiss>
nfsd4_delegations      0      0    240   16    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_stateids         0      0     96   40    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_files            0      0     64   59    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfsd4_stateowners      0      0    368   10    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nf_conntrack_expect      0      0    184   21    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nf_conntrack         344    645    264   15    1 : tunables   32   16    8 : slabdata     43     43      0 : globalstat  799662   1395   142    1 				   0    0    0    0    0 : cpustat 338856  50069 388561     65
fib6_nodes            13     67     56   67    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      64     64     1    0 				   0    0    0    0    0 : cpustat      9      4      0      0
ip6_dst_cache         16     60    256   15    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat      76     60     4    0 				   0    0    0    0    0 : cpustat     36      5     25      0
ndisc_cache            1     20    192   20    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      40     40     2    1 				   0    0    0    0    0 : cpustat      7      4     10      0
RAWv6                 11     12    672    6    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      12     12     2    0 				   0    0    0    0    0 : cpustat      9      2      0      0
UDPLITEv6              0      0    656    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
UDPv6                 10     24    656    6    1 : tunables   32   16    8 : slabdata      3      4      0 : globalstat  267214     48  1997 1993 				   0    0    0    0    0 : cpustat  76092  32292 108375      0
tw_sock_TCPv6          0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
request_sock_TCPv6      0      0    136   29    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
TCPv6                 19     27   1328    3    1 : tunables   24   12    8 : slabdata      9      9      0 : globalstat  257188     42   940  931 				   0    0    0    0    0 : cpustat  11969  43309  55265      0
smb_request            0      0    272   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     140     56    10   10 				   0    0    0    0    0 : cpustat     21     10     31      0
smb_inode_cache        3     20    384   10    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      52     20     2    0 				   0    0    0    0    0 : cpustat      0      4      1      0
nfs_direct_cache       0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
nfs_write_data        36     40    480    8    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat      40     40     5    0 				   0    0    0    0    0 : cpustat     31      5      0      0
nfs_read_data         32     32    456    8    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat    2217    168   189  185 				   0    0    0    0    0 : cpustat   1414    267   1647      2
nfs_inode_cache     1053   1056    640    6    1 : tunables   32   16    8 : slabdata    176    176      0 : globalstat    1873   1056   176    0 				   0    0    0    0    0 : cpustat    755    298      0      0
nfs_page               0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat   10512    321   165  158 				   0    1    0    0    0 : cpustat  11786    863  12404    245
rpc_buffers            8      9   2072    3    2 : tunables   24   12    8 : slabdata      3      3      0 : globalstat    2329    117   421  418 				   0    0    0    0    0 : cpustat   3981    798   4763      8
rpc_tasks              8     19    200   19    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat   12581    149   346  345 				   0    0    0    0    0 : cpustat   2064   1066   3122      0
rpc_inode_cache       16     24    488    8    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat      32     32     4    1 				   0    0    0    0    0 : cpustat     26      4     14      0
ip_fib_alias          63    156     48   78    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat     206    118     2    0 				   0    0    0    0    0 : cpustat     70     13     20      0
ip_fib_hash           62    156     48   78    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat     206    118     2    0 				   0    0    0    0    0 : cpustat     68     13     19      0
dm_snap_pending_exception    128    132     88   44    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat     132    132     3    0 				   0    0    0    0    0 : cpustat    119      9      0      0
dm_snap_exception      0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_target_io           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_io                  0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
drbd_ee_cache        381    484     88   44    1 : tunables   32   16    8 : slabdata     10     11    102 : globalstat  608903   1748  5189 1033 				   0    3    0    0    0 : cpustat 2949457  67553 2957707  59047
drbd_req_cache       419    616     88   44    1 : tunables   32   16    8 : slabdata     13     14    112 : globalstat 3164116   4592 24572 6642 				   0    4    0    0    0 : cpustat 6585171 443517 6651596 376825
raid5-md1            256    256   1000    4    1 : tunables   32   16    8 : slabdata     64     64      0 : globalstat     256    256    64    0 				   0    0    0    0    0 : cpustat    192     64      0      0
raid5-md2            256    256   1000    4    1 : tunables   32   16    8 : slabdata     64     64      0 : globalstat     256    256    64    0 				   0    0    0    0    0 : cpustat    192     64      0      0
raid5-md3            256    256   1000    4    1 : tunables   32   16    8 : slabdata     64     64      0 : globalstat     256    256    64    0 				   0    0    0    0    0 : cpustat    192     64      0      0
sgpool-128             2      3   2584    3    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       3      3     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-64              2      3   1304    3    1 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       3      3     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-32              2      6    664    6    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       6      6     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-16              2     11    344   11    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      11     11     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
sgpool-8               2     21    184   21    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
scsi_io_context        0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
uhci_urb_priv          4     67     56   67    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      77     67     1    0 				   0    0    0    0    0 : cpustat     57      6     59      0
UNIX                 593    656    456    8    1 : tunables   32   16    8 : slabdata     82     82      0 : globalstat  994927    768   644  490 				   0    1    0    0    0 : cpustat 708962  65651 771363   2750
flow_cache             0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
cfq_io_context       576   1085    112   35    1 : tunables   32   16    8 : slabdata     31     31      0 : globalstat  196213   1101    58   27 				   0    0    0    0    0 : cpustat  13216  12336  24960     16
cfq_queue            584   1050    112   35    1 : tunables   32   16    8 : slabdata     30     30      0 : globalstat  195940   1101    81   51 				   0    0    0    0    0 : cpustat  13068  12334  24801     17
mqueue_inode_cache      1      7    536    7    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       7      7     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
xfs_chashlist      13522  13572     48   78    1 : tunables   32   16    8 : slabdata    174    174      0 : globalstat   43409  13572   174    0 				   0    0    0    0    0 : cpustat  13343   2758   2510     69
xfs_ili            23826  23851    168   23    1 : tunables   32   16    8 : slabdata   1037   1037      0 : globalstat  239397  28244  2048  122 				   0    5    0    0    0 : cpustat  49254  16569  40520   1492
xfs_inode         386493 386505    408    9    1 : tunables   32   16    8 : slabdata  42945  42945      0 : globalstat  669376 386532 46399  235 				   0   12    0    0    0 : cpustat 380395  63949  55422   2444
xfs_efi_item           0      0    288   13    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat  148175    234  7382 7376 				   0    1    0    0    0 : cpustat  24805  12543  36842    506
xfs_efd_item           0      0    288   13    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat  148106    234  7374 7367 				   0    1    0    0    0 : cpustat  24743  12539  36776    506
xfs_buf_item          44     44    176   22    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  563618    436  2836 2805 				   0    1    0    0    0 : cpustat 565743  38692 604227    177
fstrm_item             0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfs_mru_cache_elem      0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfs_acl                0      0    328   12    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     808     96    64   64 				   0    0    0    0    0 : cpustat 441456     67 441523      0
xfs_ifork              0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfs_dabuf             66     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat  541986    138   976  975 				   0    0    0    0    0 : cpustat 1380537  34134 1414671      0
xfs_da_state           0      0    360   11    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat   26567     99  1726 1726 				   0    0    0    0    0 : cpustat 160395   2394 162789      0
xfs_trans             34     36    656    6    1 : tunables   32   16    8 : slabdata      6      6      0 : globalstat  947093   1320 46740 24952 				   0   25    0    0    0 : cpustat 1525806 136923 1606327  56401
xfs_btree_cur         23     23    168   23    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat  501297    115  4406 4405 				   0    0    0    0    0 : cpustat 473409  36511 509920      0
xfs_bmap_free_item      0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat  185635    124  3699 3699 				   0    0    0    0    0 : cpustat  28941  11638  40579      0
xfs_buf              119    198    216   18    1 : tunables   32   16    8 : slabdata     11     11      0 : globalstat  845845    592   710  319 				   0    1    0    0    0 : cpustat 3302165  55177 3355253   2029
xfs_ioend            142    288     80   48    1 : tunables   32   16    8 : slabdata      6      6     54 : globalstat 1326557   1136  8289 5288 				   0    2    0    0    0 : cpustat 2060028 148748 2129596  79148
xfs_vnode         386491 386510    392   10    1 : tunables   32   16    8 : slabdata  38651  38651      0 : globalstat  811017 386520 41375  391 				   0   12    0    0    0 : cpustat 454442  68642 134173   2437
ext2_inode_cache       0      0    496    8    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext2_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
journal_handle         0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
journal_head           0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
revoke_table           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
revoke_record          0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext3_inode_cache       0      0    512    8    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext3_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dnotify_cache          6     78     48   78    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      5      1      0      0
dquot                  0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_event_cache      0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_watch_cache      1     59     64   59    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     16     2    1 				   0    0    0    0    0 : cpustat      0      2      1      0
kioctx                 0      0    208   19    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
kiocb                  0      0    160   24    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fasync_cache           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     192     16    12   12 				   0    0    0    0    0 : cpustat      1     12     13      0
shmem_inode_cache    573    592    464    8    1 : tunables   32   16    8 : slabdata     74     74      0 : globalstat  648458    624   106   32 				   0    0    0    0    0 : cpustat  69267  40609 109336      2
nsproxy                0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
posix_timers_cache      0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
uid_cache             40     96     80   48    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  628587     96     4    2 				   0    0    0    0    0 : cpustat  16987  39290  56256      0
ip_mrt_cache           0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
UDP-Lite               0      0    544    7    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
tcp_bind_bucket       86    368     40   92    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat  339197   1048    12    0 				   0    0    0    0    0 : cpustat  31949  21273  53037    129
inet_peer_cache       16    106     72   53    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat    6821     69     2    0 				   0    0    0    0    0 : cpustat      8    427    419      0
secpath_cache          0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfrm_dst_cache         0      0    288   13    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ip_dst_cache         361    645    264   15    1 : tunables   32   16    8 : slabdata     43     43      0 : globalstat  847198   1305  2414    3 				   0    1    0    0    0 : cpustat 143578  57525 190304  10476
arp_cache             19     84    184   21    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat   46885     84     6    2 				   0    0    0    0    0 : cpustat    199   2942   3122      0
RAW                   10     14    528    7    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat    3122     63   198  196 				   0    0    0    0    0 : cpustat   1630    696   2316      0
UDP                   69     98    544    7    1 : tunables   32   16    8 : slabdata     13     14      0 : globalstat  651647    133  4480 4466 				   0    0    0    0    0 : cpustat 286700  48762 335418      0
tw_sock_TCP           41     96    120   32    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat  553342   1056   417  353 				   0    0    0    0    0 : cpustat  53866  35404  88741    519
request_sock_TCP      57     80     96   40    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  821943    272  2089 2084 				   0    0    0    0    0 : cpustat 148260  54724 202959     25
TCP                  186    186   1216    3    1 : tunables   24   12    8 : slabdata     62     62      0 : globalstat  529711    297  7138 7076 				   0    2    0    0    0 : cpustat 148350  54386 201989    597
eventpoll_pwq        224    413     64   59    1 : tunables   32   16    8 : slabdata      7      7      0 : globalstat  472600    386     9    1 				   0    0    0    0    0 : cpustat 257269  29568 286592     40
eventpoll_epi        224    360     96   40    1 : tunables   32   16    8 : slabdata      9      9      0 : globalstat  472524    381    15    3 				   0    0    0    0    0 : cpustat 257267  29570 286592     40
blkdev_ioc           123    268     56   67    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat   74125    268    14   10 				   0    0    0    0    0 : cpustat   2860   4659   7390      6
blkdev_queue          31     48   1008    4    1 : tunables   32   16    8 : slabdata     12     12      0 : globalstat      79     48    12    0 				   0    0    0    0    0 : cpustat     16     15      0      0
blkdev_requests      317    864    216   18    1 : tunables   32   16    8 : slabdata     48     48    128 : globalstat 4595374   1258 15833  208 				   0    2    0    0    0 : cpustat 46465376 1496845 46516818 1445367
biovec-256             2      2   3096    2    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat      68     68    34   33 				   0    0    0    0    0 : cpustat     34     34     66      0
biovec-128             2      5   1560    5    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat     249    210    48   41 				   0    0    0    0    0 : cpustat    276     57    316     15
biovec-64             22     30    792    5    1 : tunables   32   16    8 : slabdata      6      6      0 : globalstat  647746    625 66725 60768 				   0   18    0    0    0 : cpustat 713265 110950 799309  24904
biovec-16             35     36    216   18    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat  684498    216  5072 5027 				   0    2    0    0    0 : cpustat 325180  50766 373953   1991
biovec-4              43     53     72   53    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat  524720    477  1210 1036 				   0    1    0    0    0 : cpustat 339248  37378 372477   4147
biovec-1             283    828     40   92    1 : tunables   32   16    8 : slabdata      9      9    128 : globalstat 7921226  11272  4735    2 				   0    2    0    0    0 : cpustat 37637744 1406322 37684469 1359595
bio                  260    800     96   40    1 : tunables   32   16    8 : slabdata     20     20     80 : globalstat 8239361  11296 22266   35 				   0    3    0    0    0 : cpustat 39147728 1473516 39201720 1419522
sock_inode_cache     830   1070    400   10    1 : tunables   32   16    8 : slabdata    107    107      0 : globalstat  740372   1120   204   56 				   0    0    0    0    0 : cpustat 1433842  49174 1479297   2980
skbuff_fclone_cache    115    120    392   10    1 : tunables   32   16    8 : slabdata     12     12     16 : globalstat  583511    280  4315 4300 				   0    6    0    0    0 : cpustat 9013937 224325 9049458 188797
skbuff_head_cache   1395   1938    208   19    1 : tunables   32   16    8 : slabdata    102    102      0 : globalstat  415251   4693   262    0 				   0    5    0    0    0 : cpustat 42151297 548562 42160738 537842
file_lock_cache       63    160    120   32    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat  745627    189    86   81 				   0    0    0    0    0 : cpustat 5982441  46774 6029168      0
Acpi-Operand         561    590     64   59    1 : tunables   32   16    8 : slabdata     10     10      0 : globalstat     614    579    10    0 				   0    0    0    0    0 : cpustat   1785     52   1266     10
Acpi-ParseExt          0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     170    106     4    2 				   0    0    0    0    0 : cpustat   1901     20   1909     12
Acpi-Parse             0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     112     48     3    2 				   0    0    0    0    0 : cpustat   2646      7   2653      0
Acpi-State             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     133     69     4    3 				   0    0    0    0    0 : cpustat   4616      9   4625      0
Acpi-Namespace       422    468     48   78    1 : tunables   32   16    8 : slabdata      6      6      0 : globalstat     422    422     6    0 				   0    0    0    0    0 : cpustat    395     27      0      0
proc_inode_cache    1877   2140    376   10    1 : tunables   32   16    8 : slabdata    214    214      0 : globalstat  861949   3430   687  155 				   0    0    0    0    0 : cpustat 639218  54808 691460    726
sigqueue              81    115    168   23    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat  657007    200   465  459 				   0    1    0    0    0 : cpustat 2060337 117019 2098328  79028
radix_tree_node    56266  56292    312   12    1 : tunables   32   16    8 : slabdata   4691   4691      0 : globalstat  466510  61440  5534  174 				   0    7    0    0    0 : cpustat 249389  32256 224194   1203
bdev_cache            50     96    472    8    1 : tunables   32   16    8 : slabdata     12     12      0 : globalstat     229     96    12    0 				   0    0    0    0    0 : cpustat    120     21     91      0
sysfs_dir_cache     7833   7872     80   48    1 : tunables   32   16    8 : slabdata    164    164      0 : globalstat    8140   7856   164    0 				   0    0    0    0    0 : cpustat   7698    515    380      0
mnt_cache             39    116    136   29    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat     297    103     4    0 				   0    0    0    0    0 : cpustat     21     19      1      0
inode_cache          193    374    360   11    1 : tunables   32   16    8 : slabdata     34     34      0 : globalstat  641265   2090   883  697 				   0   12    0    0    0 : cpustat 148151  40772 188497    309
dentry            425976 425976    160   24    1 : tunables   32   16    8 : slabdata  17749  17749      0 : globalstat 1445145 425992 23668   51 				   0    4    0    0    0 : cpustat 3101195 113333 2765767  22902
filp                6407  18720    160   24    1 : tunables   32   16    8 : slabdata    780    780     96 : globalstat 3280184  22960  2130   71 				   0    6    0    0    0 : cpustat 14685939 647868 14739187 588471
names_cache           43     47   4096    1    1 : tunables   24   12    8 : slabdata     43     47      0 : globalstat  239891    119 47517 47470 				   0   41    0    0    0 : cpustat 38549707  82965 38627347   5325
key_jar               74    105    112   35    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat  676064    156    26   23 				   0    0    0    0    0 : cpustat  70270  42284 112512      0
idr_layer_cache       88    120    160   24    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat     504    136     6    1 				   0    0    0    0    0 : cpustat    196     34    142      0
buffer_head       794845 794976     80   48    1 : tunables   32   16    8 : slabdata  16562  16562     32 : globalstat 2313373 794960 19236  157 				   0    3    0    0    0 : cpustat 5189617 331841 4504768 221912
mm_struct            389    440    456    8    1 : tunables   32   16    8 : slabdata     55     55      0 : globalstat  866743    496   663  583 				   0    0    0    0    0 : cpustat 560425  56839 614822   2151
vm_area_struct     16324  25795    112   35    1 : tunables   32   16    8 : slabdata    737    737     96 : globalstat 3086332  27281  1784   25 				   0    4    0    0    0 : cpustat 23836095 914708 23898494 836218
fs_cache             393    531     64   59    1 : tunables   32   16    8 : slabdata      9      9      0 : globalstat  897242    522    13    4 				   0    0    0    0    0 : cpustat 314122  58691 369722   2787
files_cache          387    490    280   14    1 : tunables   32   16    8 : slabdata     35     35      0 : globalstat  902879    532   110   54 				   0    1    0    0    0 : cpustat 313680  59132 369615   2900
signal_cache         501    560    472    8    1 : tunables   32   16    8 : slabdata     70     70      0 : globalstat  878195    656   619  539 				   0    2    0    0    0 : cpustat 317661  56146 372640    740
sighand_cache        482    486   1328    3    1 : tunables   24   12    8 : slabdata    161    162      0 : globalstat  646396    615  7154 6990 				   0    1    0    0    0 : cpustat 310422  62699 371594   1100
task_struct          570    570   1360    3    1 : tunables   24   12    8 : slabdata    190    190      0 : globalstat  668675    690  7415 7183 				   0    3    0    0    0 : cpustat 323143  64312 385522   1432
anon_vma            3618   4876     40   92    1 : tunables   32   16    8 : slabdata     53     53     16 : globalstat 1581946   4800    69    3 				   0    1    0    0    0 : cpustat 4076459 166059 4161166  77911
pmd                  940    940   4096    1    1 : tunables   24   12    8 : slabdata    940    940      0 : globalstat  862430   1269 57660 52384 				   0   97    0    0    0 : cpustat 1708852 142940 1835533  15386
pid                  584    767     64   59    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat  906649    750    16    2 				   0    0    0    0    0 : cpustat 329916  57532 385933   1018
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072            2      2 131072    1   32 : tunables    8    4    0 : slabdata      2      2      0 : globalstat       2      2     2    0 				   0    0    0    0    0 : cpustat      0      2      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-65536             2      2  65536    1   16 : tunables    8    4    0 : slabdata      2      2      0 : globalstat       4      3     3    1 				   0    0    0    0    0 : cpustat      0      4      2      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       1      1     1    1 				   0    0    0    0    0 : cpustat      2      1      3      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-16384           270    294  16384    1    4 : tunables    8    4    0 : slabdata    270    294      0 : globalstat 3516777    321 12222 5265 				   0   33    0    0    0 : cpustat 2883025 890709 2938527 834950
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-8192             21     21   8192    1    2 : tunables    8    4    0 : slabdata     21     21      0 : globalstat 1169879     88 17943 17434 				   0   33    0    0    0 : cpustat 902200 308848 942028 268999
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4096            797    797   4096    1    1 : tunables   24   12    8 : slabdata    797    797      0 : globalstat  713783    956 62223 60550 				   0   97    0    0    0 : cpustat 3065218 145591 3187693  22345
size-2048(DMA)         0      0   2072    3    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2048           1310   1389   2072    3    2 : tunables   24   12    8 : slabdata    463    463      0 : globalstat  246723   1464  1083  580 				   0   32    0    0    0 : cpustat 7617180  58434 7634243  40137
size-1024(DMA)         0      0   1048    7    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1024            745    833   1048    7    2 : tunables   24   12    8 : slabdata    119    119      0 : globalstat  444771    938   297  153 				   0    5    0    0    0 : cpustat 15244362 383299 15265342 361690
size-512(DMA)          0      0    536    7    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-512             710    763    536    7    1 : tunables   32   16    8 : slabdata    109    109      0 : globalstat  407124    882   359  222 				   0    2    0    0    0 : cpustat 14768006 404798 14778919 393278
size-256(DMA)          0      0    280   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-256             333    364    280   14    1 : tunables   32   16    8 : slabdata     26     26      0 : globalstat  787900    406  1621 1583 				   0    1    0    0    0 : cpustat 554775  53785 604387   3921
size-192(DMA)          0      0    216   18    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-192            3830   3870    216   18    1 : tunables   32   16    8 : slabdata    215    215      0 : globalstat  911778   3922   312   92 				   0    0    0    0    0 : cpustat 1240863  57400 1294422    106
size-128(DMA)          0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-128            9102   9152    152   26    1 : tunables   32   16    8 : slabdata    352    352      0 : globalstat   93791   9152   369   16 				   0    0    0    0    0 : cpustat  43165   6079  40086     56
size-64(DMA)           0      0     88   44    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32(DMA)           0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-64            41735  41888     88   44    1 : tunables   32   16    8 : slabdata    952    952      0 : globalstat  764753  41888  1084    1 				   0    0    0    0    0 : cpustat 774192  48648 779861   1311
size-32             8350   8844     56   67    1 : tunables   32   16    8 : slabdata    132    132      0 : globalstat  945360   8825   132    0 				   0    0    0    0    0 : cpustat 4171677  94421 4220718  37129
kmem_cache           180    210    256   15    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat     340    210    14    0 				   0    0    0    0    0 : cpustat    120     60      0      0

--------------070007060605030807030603
Content-Type: text/plain;
 name="slabtop"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slabtop"

 Active / Total Objects (% used)    : 1031308 / 1501486 (68.7%)
 Active / Total Slabs (% used)      : 87577 / 87659 (99.9%)
 Active / Total Caches (% used)     : 116 / 179 (64.8%)
 Active / Total Size (% used)       : 275759.16K / 331390.36K (83.2%)
 Minimum / Average / Maximum Object : 0.04K / 0.22K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
460752 150236  32%    0.08K   9599       48     38396K buffer_head
244413 225674  92%    0.40K  27157        9    108628K xfs_inode
242010 225657  93%    0.38K  24201       10     96804K xfs_vnode
215280 171465  79%    0.16K   8970       24     35880K dentry
 88368  88272  99%    0.30K   7364       12     29456K radix_tree_node
 40456  14457  35%    0.15K   1556       26      6224K size-128
 34866  30182  86%    0.05K    447       78      1788K xfs_chashlist
 30492  28569  93%    0.09K    693       44      2772K size-64
 26936  26931  99%    0.10K    728       37      2912K flow_cache
 23870  11671  48%    0.11K    682       35      2728K vm_area_struct
 12696   4196  33%    0.04K    138       92       552K anon_vma
 10653   7978  74%    0.05K    159       67       636K size-32
 10632   4728  44%    0.16K    443       24      1772K filp
  8448   8403  99%    0.08K    176       48       704K sysfs_dir_cache
  8326   5410  64%    0.16K    362       23      1448K xfs_ili
  2682   2158  80%    0.21K    149       18       596K size-192
  2508   1456  58%    0.20K    132       19       528K skbuff_head_cache
  2220   1423  64%    0.26K    148       15       592K ip_dst_cache
  2205    550  24%    0.11K     63       35       252K cfq_io_context
  2170    557  25%    0.11K     62       35       248K cfq_queue
  2002   1959  97%    0.52K    286        7      1144K size-512
  1815   1298  71%    0.26K    121       15       484K nf_conntrack
  1690   1514  89%    0.37K    169       10       676K proc_inode_cache
  1620   1005  62%    0.39K    162       10       648K sock_inode_cache
  1380   1352  97%    2.02K    460        3      3680K size-2048
  1180    537  45%    0.06K     20       59        80K pid
  1003    328  32%    0.06K     17       59        68K fs_cache
   973    898  92%    1.02K    139        7      1112K size-1024
   960    684  71%    0.45K    120        8       480K UNIX
   855    809  94%    4.00K    855        1      3420K pmd
   784    715  91%    0.27K     56       14       224K size-256
   658    320  48%    0.27K     47       14       188K files_cache
   656    460  70%    0.46K     82        8       328K signal_cache
   649    263  40%    0.06K     11       59        44K eventpoll_pwq
   644    243  37%    0.04K      7       92        28K biovec-1
   644    177  27%    0.04K      7       92        28K tcp_bind_bucket
   640    263  41%    0.09K     16       40        64K eventpoll_epi
   624    230  36%    0.28K     48       13       192K xfrm_dst_cache
   612    269  43%    0.21K     34       18       136K blkdev_requests
   609    529  86%    1.33K    203        3       812K task_struct
   608    527  86%    0.45K     76        8       304K shmem_inode_cache
   600    245  40%    0.09K     15       40        60K bio
   590    561  95%    0.06K     10       59        40K Acpi-Operand
   484    330  68%    0.09K     11       44        44K drbd_req_cache
   469     93  19%    0.05K      7       67        28K blkdev_ioc
   468    434  92%    1.30K    156        3       624K sighand_cache
   468    422  90%    0.05K      6       78        24K Acpi-Namespace
   456    315  69%    0.45K     57        8       228K mm_struct
   315     70  22%    0.11K      9       35        36K key_jar
   308    278  90%    0.09K      7       44        28K drbd_ee_cache
   297    142  47%    0.35K     27       11       108K inode_cache
   288     35  12%    0.08K      6       48        24K uid_cache
   282    278  98%   16.00K    282        1      4512K size-16384
   278    256  92%    4.00K    278        1      1112K size-4096
   256    256 100%    0.98K     64        4       256K raid5-md1
   256    256 100%    0.98K     64        4       256K raid5-md2
   256    256 100%    0.98K     64        4       256K raid5-md3
   252    144  57%    0.21K     14       18        56K xfs_buf
   243    243 100%    1.19K     81        3       324K TCP
   224    154  68%    0.12K      7       32        28K file_lock_cache
   212     31  14%    0.07K      4       53        16K biovec-4
   201    153  76%    0.05K      3       67        12K secpath_cache
   195    178  91%    0.25K     13       15        52K kmem_cache
   192    140  72%    0.12K      6       32        24K tw_sock_TCP
   176    102  57%    0.17K      8       22        32K xfs_buf_item
   170    144  84%    0.38K     17       10        68K skbuff_fclone_cache
   160    160 100%    0.09K      4       40        16K request_sock_TCP
   156     73  46%    0.05K      2       78         8K ip_fib_hash
   156     73  46%    0.05K      2       78         8K ip_fib_alias
   147     42  28%    0.18K      7       21        28K arp_cache
   134      4   2%    0.05K      2       67         8K uhci_urb_priv
   132    128  96%    0.09K      3       44        12K dm_snap_pending_exception
   120     87  72%    0.16K      5       24        20K idr_layer_cache
   119    101  84%    0.53K     17        7        68K UDP
   115    102  88%    0.16K      5       23        20K sigqueue
   114     46  40%    0.64K     19        6        76K xfs_trans
   106     43  40%    0.07K      2       53         8K inet_peer_cache
    96     51  53%    0.08K      2       48         8K xfs_ioend
    92      5   5%    0.04K      1       92         4K xfs_bmap_free_item
    92     23  25%    0.16K      4       23        16K xfs_btree_cur
    92     25  27%    0.04K      1       92         4K xfs_dabuf
    87     28  32%    0.13K      3       29        12K mnt_cache


--------------070007060605030807030603--
