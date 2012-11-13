Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAD9Bx7w063901 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 03:11:59 -0600
Received: from galenis.iv.lt (galenis.iv.lt [195.14.170.242]) by cuda.sgi.com
	with ESMTP id 34uaXWVXoGAz2K70 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Nov 2012 01:13:59 -0800 (PST)
Message-ID: <50A20F53.80405@iv.lt>
Date: Tue, 13 Nov 2012 11:13:55 +0200
From: Linas Jankauskas <linas.j@iv.lt>
MIME-Version: 1.0
Subject: Re: Slow performance after ~4.5TB
References: <50A0AFD5.2020607@iv.lt> <20121112090448.GS24575@dastard>
	<50A0C590.6020602@iv.lt> <20121112123222.GT24575@dastard>
	<50A10077.2060908@iv.lt> <20121112223623.GV24575@dastard>
In-Reply-To: <20121112223623.GV24575@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

trace-cmd output was about 300mb, so im pasting first 100 lines of it, 
is it enough?:

version = 6
CPU 6 is empty
cpus=8
            rsync-32149 [001] 1190711.373757: xfs_perag_get:        dev 
8:5 agno 7 refcount 5598 caller _xfs_buf_find
            rsync-32149 [001] 1190711.373759: xfs_perag_put:        dev 
8:5 agno 7 refcount 5597 caller _xfs_buf_find
            rsync-32149 [001] 1190711.373759: xfs_buf_cond_lock:    dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32149 [001] 1190711.373760: xfs_buf_find:         dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32149 [001] 1190711.373760: xfs_buf_get:          dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32149 [001] 1190711.373761: xfs_buf_read:         dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_trans_read_buf
            rsync-32149 [001] 1190711.373761: xfs_buf_hold:         dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_init
            rsync-32149 [001] 1190711.373762: xfs_trans_read_buf:   dev 
8:5 bno 0x3800929b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88017bbb3350 liflags
            rsync-32149 [001] 1190711.373762: xfs_trans_brelse:     dev 
8:5 bno 0x381581db0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88015db19730 liflags
            rsync-32149 [001] 1190711.373762: xfs_buf_item_relse:   dev 
8:5 bno 0x381581db0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373763: xfs_buf_rele:         dev 
8:5 bno 0x381581db0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_relse
            rsync-32149 [001] 1190711.373763: xfs_buf_unlock:       dev 
8:5 bno 0x381581db0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373764: xfs_buf_rele:         dev 
8:5 bno 0x381581db0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373764: xfs_perag_get:        dev 
8:5 agno 7 refcount 5598 caller _xfs_buf_find
            rsync-32149 [001] 1190711.373765: xfs_perag_put:        dev 
8:5 agno 7 refcount 5597 caller _xfs_buf_find
            rsync-32149 [001] 1190711.373765: xfs_buf_cond_lock:    dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32149 [001] 1190711.373766: xfs_buf_find:         dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32149 [001] 1190711.373766: xfs_buf_get:          dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32149 [001] 1190711.373766: xfs_buf_read:         dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_readahead
            rsync-32149 [001] 1190711.373767: xfs_buf_unlock:       dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read
            rsync-32149 [001] 1190711.373767: xfs_buf_rele:         dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read
            rsync-32147 [000] 1190711.373777: xfs_perag_get:        dev 
8:5 agno 6 refcount 6690 caller _xfs_buf_find
            rsync-32147 [000] 1190711.373778: xfs_perag_put:        dev 
8:5 agno 6 refcount 6689 caller _xfs_buf_find
            rsync-32147 [000] 1190711.373779: xfs_buf_cond_lock:    dev 
8:5 bno 0x30da91360 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32147 [000] 1190711.373779: xfs_buf_find:         dev 
8:5 bno 0x30da91360 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32147 [000] 1190711.373780: xfs_buf_get:          dev 
8:5 bno 0x30da91360 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32147 [000] 1190711.373780: xfs_buf_read:         dev 
8:5 bno 0x30da91360 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_trans_read_buf
            rsync-32147 [000] 1190711.373781: xfs_buf_hold:         dev 
8:5 bno 0x30da91360 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_init
            rsync-32147 [000] 1190711.373781: xfs_trans_read_buf:   dev 
8:5 bno 0x30da91360 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88017bbb3fd0 liflags
            rsync-32147 [000] 1190711.373782: xfs_trans_brelse:     dev 
8:5 bno 0x30da8b4e0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88017bbb3230 liflags
            rsync-32147 [000] 1190711.373782: xfs_buf_item_relse:   dev 
8:5 bno 0x30da8b4e0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32147 [000] 1190711.373783: xfs_buf_rele:         dev 
8:5 bno 0x30da8b4e0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_relse
            rsync-32147 [000] 1190711.373783: xfs_buf_unlock:       dev 
8:5 bno 0x30da8b4e0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32147 [000] 1190711.373783: xfs_buf_rele:         dev 
8:5 bno 0x30da8b4e0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32147 [000] 1190711.373784: xfs_perag_get:        dev 
8:5 agno 6 refcount 6690 caller _xfs_buf_find
            rsync-32147 [000] 1190711.373785: xfs_perag_put:        dev 
8:5 agno 6 refcount 6689 caller _xfs_buf_find
            rsync-32147 [000] 1190711.373785: xfs_buf_cond_lock:    dev 
8:5 bno 0x30da97360 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32147 [000] 1190711.373786: xfs_buf_find:         dev 
8:5 bno 0x30da97360 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32147 [000] 1190711.373786: xfs_buf_get:          dev 
8:5 bno 0x30da97360 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32147 [000] 1190711.373786: xfs_buf_read:         dev 
8:5 bno 0x30da97360 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_readahead
            rsync-32147 [000] 1190711.373787: xfs_buf_unlock:       dev 
8:5 bno 0x30da97360 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read
            rsync-32147 [000] 1190711.373787: xfs_buf_rele:         dev 
8:5 bno 0x30da97360 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read
            rsync-1303  [005] 1190711.373803: xfs_perag_get:        dev 
8:5 agno 4 refcount 5414 caller _xfs_buf_find
            rsync-1303  [005] 1190711.373804: xfs_perag_put:        dev 
8:5 agno 4 refcount 5413 caller _xfs_buf_find
            rsync-1303  [005] 1190711.373805: xfs_buf_cond_lock:    dev 
8:5 bno 0x20ae4d690 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-1303  [005] 1190711.373805: xfs_buf_find:         dev 
8:5 bno 0x20ae4d690 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_get
            rsync-1303  [005] 1190711.373806: xfs_buf_get:          dev 
8:5 bno 0x20ae4d690 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_read
            rsync-1303  [005] 1190711.373806: xfs_buf_read:         dev 
8:5 bno 0x20ae4d690 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_trans_read_buf
            rsync-32146 [003] 1190711.373807: xfs_perag_get:        dev 
8:5 agno 2 refcount 6630 caller _xfs_buf_find
            rsync-1303  [005] 1190711.373807: xfs_buf_hold:         dev 
8:5 bno 0x20ae4d690 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_init
            rsync-1303  [005] 1190711.373807: xfs_trans_read_buf:   dev 
8:5 bno 0x20ae4d690 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88015db19db0 liflags
            rsync-1303  [005] 1190711.373808: xfs_trans_brelse:     dev 
8:5 bno 0x2001c7f60 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff8801f5dd66f0 liflags
            rsync-32146 [003] 1190711.373808: xfs_perag_put:        dev 
8:5 agno 2 refcount 6629 caller _xfs_buf_find
            rsync-1303  [005] 1190711.373808: xfs_buf_item_relse:   dev 
8:5 bno 0x2001c7f60 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32146 [003] 1190711.373808: xfs_buf_cond_lock:    dev 
8:5 bno 0x114000d30 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-1303  [005] 1190711.373808: xfs_buf_rele:         dev 
8:5 bno 0x2001c7f60 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_relse
            rsync-32146 [003] 1190711.373809: xfs_buf_find:         dev 
8:5 bno 0x114000d30 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_get
            rsync-1303  [005] 1190711.373809: xfs_buf_unlock:       dev 
8:5 bno 0x2001c7f60 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32146 [003] 1190711.373809: xfs_buf_get:          dev 
8:5 bno 0x114000d30 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32149 [001] 1190711.373809: xfs_perag_get:        dev 
8:5 agno 7 refcount 5598 caller _xfs_buf_find
            rsync-1303  [005] 1190711.373809: xfs_buf_rele:         dev 
8:5 bno 0x2001c7f60 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32146 [003] 1190711.373810: xfs_buf_read:         dev 
8:5 bno 0x114000d30 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_trans_read_buf
            rsync-32149 [001] 1190711.373810: xfs_perag_put:        dev 
8:5 agno 7 refcount 5597 caller _xfs_buf_find
            rsync-32146 [003] 1190711.373810: xfs_buf_hold:         dev 
8:5 bno 0x114000d30 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_init
            rsync-1303  [005] 1190711.373810: xfs_perag_get:        dev 
8:5 agno 4 refcount 5414 caller _xfs_buf_find
            rsync-32149 [001] 1190711.373810: xfs_buf_cond_lock:    dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32149 [001] 1190711.373811: xfs_buf_find:         dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32146 [003] 1190711.373811: xfs_trans_read_buf:   dev 
8:5 bno 0x114000d30 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff8801f5dd6f70 liflags
            rsync-1303  [005] 1190711.373811: xfs_perag_put:        dev 
8:5 agno 4 refcount 5413 caller _xfs_buf_find
            rsync-32149 [001] 1190711.373811: xfs_buf_get:          dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32146 [003] 1190711.373811: xfs_trans_brelse:     dev 
8:5 bno 0x113ff61b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88015db19f90 liflags
            rsync-1303  [005] 1190711.373811: xfs_buf_cond_lock:    dev 
8:5 bno 0x20ae7a790 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32149 [001] 1190711.373812: xfs_buf_read:         dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|MAPPED|LOCK|DONT_BLOCK caller xfs_trans_read_buf
            rsync-1303  [005] 1190711.373812: xfs_buf_find:         dev 
8:5 bno 0x20ae7a790 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32146 [003] 1190711.373812: xfs_buf_item_relse:   dev 
8:5 bno 0x113ff61b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373812: xfs_buf_hold:         dev 
8:5 bno 0x3815869b0 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_init
            rsync-32146 [003] 1190711.373812: xfs_buf_rele:         dev 
8:5 bno 0x113ff61b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_relse
            rsync-1303  [005] 1190711.373812: xfs_buf_get:          dev 
8:5 bno 0x20ae7a790 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32146 [003] 1190711.373813: xfs_buf_unlock:       dev 
8:5 bno 0x113ff61b0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373813: xfs_trans_read_buf:   dev 
8:5 bno 0x3815869b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88015db19730 liflags
            rsync-1303  [005] 1190711.373813: xfs_buf_read:         dev 
8:5 bno 0x20ae7a790 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_readahead
            rsync-32146 [003] 1190711.373813: xfs_buf_rele:         dev 
8:5 bno 0x113ff61b0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373813: xfs_trans_brelse:     dev 
8:5 bno 0x3800929b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES recur 0 refcount 1 bliflags  lidesc 
0x0xffff88017bbb3350 liflags
            rsync-1303  [005] 1190711.373813: xfs_buf_unlock:       dev 
8:5 bno 0x20ae7a790 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read
            rsync-32146 [003] 1190711.373814: xfs_perag_get:        dev 
8:5 agno 2 refcount 6630 caller _xfs_buf_find
            rsync-1303  [005] 1190711.373814: xfs_buf_rele:         dev 
8:5 bno 0x20ae7a790 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read
            rsync-32149 [001] 1190711.373814: xfs_buf_item_relse:   dev 
8:5 bno 0x3800929b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32149 [001] 1190711.373814: xfs_buf_rele:         dev 
8:5 bno 0x3800929b0 len 0x1000 hold 3 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_item_relse
            rsync-32146 [003] 1190711.373814: xfs_perag_put:        dev 
8:5 agno 2 refcount 6629 caller _xfs_buf_find
            rsync-32146 [003] 1190711.373815: xfs_buf_cond_lock:    dev 
8:5 bno 0x11400d130 len 0x1000 hold 2 pincount 0 lock 0 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller _xfs_buf_find
            rsync-32149 [001] 1190711.373815: xfs_buf_unlock:       dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32146 [003] 1190711.373815: xfs_buf_find:         dev 
8:5 bno 0x11400d130 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_get
            rsync-32149 [001] 1190711.373815: xfs_buf_rele:         dev 
8:5 bno 0x3800929b0 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_trans_brelse
            rsync-32146 [003] 1190711.373815: xfs_buf_get:          dev 
8:5 bno 0x11400d130 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_read
            rsync-32146 [003] 1190711.373816: xfs_buf_read:         dev 
8:5 bno 0x11400d130 len 0x1000 hold 2 pincount 0 lock 0 flags 
READ|ASYNC|READ_AHEAD|TRYLOCK|DONT_BLOCK caller xfs_buf_readahead
            rsync-32149 [001] 1190711.373816: xfs_perag_get:        dev 
8:5 agno 7 refcount 5598 caller _xfs_buf_find
            rsync-32146 [003] 1190711.373816: xfs_buf_unlock:       dev 
8:5 bno 0x11400d130 len 0x1000 hold 2 pincount 0 lock 1 flags 
MAPPED|ASYNC|DONE|TRYLOCK|PAGES caller xfs_buf_read


Rsync command:

/usr/bin/rsync -e ssh -c blowfish -a --inplace --numeric-ids 
--hard-links --ignore-errors --delete --force

Files are from hosting servers. So files are from websites, emails and 
databases. Average file size is 84KB. In this situation we are making 
new copies, but same thing is happening when rsyning existing copies.


xfs_bmap on one random file:

  EXT: FILE-OFFSET      BLOCK-RANGE              AG AG-OFFSET 
    TOTAL FLAGS
    0: [0..991]:        26524782560..26524783551 12 
(754978880..754979871)   992 00000



agno: 0

    from      to extents  blocks    pct
       1       1    5565    5565   0.00
       2       3    3381    7425   0.00
       4       7    3476   18086   0.01
       8      15    8645   99098   0.04
      16      31   13685  316007   0.12
      32      63   16652  762551   0.29
      64     127   14781 1338097   0.51
     128     255   10989 1980905   0.76
     256     511    6616 2364858   0.91
     512    1023    3312 2350027   0.90
    1024    2047    1593 2239507   0.86
    2048    4095     697 1974083   0.76
    4096    8191     259 1420100   0.55
    8192   16383      52  577910   0.22
   16384   32767      13  258700   0.10
  262144  524287       2  905941   0.35
134217728 268435455       1 243722991  93.62
total free extents 89719
total free blocks 260341851
average free extent size 2901.75

agno: 1

    from      to extents  blocks    pct
       1       1   74085   74085   0.05
       2       3   97017  237788   0.15
       4       7  165766  918075   0.59
       8      15 2557055 35731152  22.78
      16      31      14     265   0.00
      64     127       1     119   0.00
    2048    4095      40  163151   0.10
    4096    8191      12   97947   0.06
   16384   32767      23  700277   0.45
   32768   65535       8  457394   0.29
   65536  131071      10 1126595   0.72
  131072  262143       9 1943656   1.24
  524288 1048575       2 1361471   0.87
1048576 2097151       1 1342854   0.86
67108864 134217727       1 112675044  71.85
total free extents 2894044
total free blocks 156829873
average free extent size 54.1906

agno: 2

    from      to extents  blocks    pct
       1       1   63514   63514   0.03
       2       3   86641  212869   0.11
       4       7  156652  869910   0.46
       8      15 2477693 34631683  18.51
      16      31    6295  188101   0.10
      32      63    4951  251487   0.13
      64     127    3059  283379   0.15
     128     255    1299  244132   0.13
     256     511     814  320244   0.17
     512    1023     334  278097   0.15
    1024    2047     125  224117   0.12
    2048    4095      86  275194   0.15
    4096    8191      56  380536   0.20
    8192   16383      35  490691   0.26
   16384   32767      48 1414133   0.76
   32768   65535      21 1194392   0.64
   65536  131071      12 1176678   0.63
  131072  262143       7 1567859   0.84
  262144  524287       7 2569301   1.37
  524288 1048575       2 1307738   0.70
1048576 2097151       1 1057412   0.57
2097152 4194303       1 2342065   1.25
134217728 268435455       1 135798313  72.56
total free extents 2801654
total free blocks 187141845
average free extent size 66.7969

agno: 3

    from      to extents  blocks    pct
       1       1   66380   66380   0.04
       2       3   89079  218602   0.13
       4       7  158852  882349   0.52
       8      15 2479273 34656696  20.37
      16      31    5986  182099   0.11
      32      63    5149  267460   0.16
      64     127    3820  360583   0.21
     128     255    1398  286440   0.17
     256     511    1197  495052   0.29
     512    1023     306  277054   0.16
    8192   16383       1   11485   0.01
   16384   32767      22  684677   0.40
   32768   65535      12  745348   0.44
   65536  131071       3  346412   0.20
  131072  262143       3  679326   0.40
  262144  524287       3 1499739   0.88
  524288 1048575       1  614477   0.36
2097152 4194303       2 5534718   3.25
67108864 134217727       1 122351455  71.90
total free extents 2811488
total free blocks 170160352
average free extent size 60.5232

agno: 4

    from      to extents  blocks    pct
       1       1   57933   57933   0.03
       2       3   81845  201090   0.12
       4       7  150730  838247   0.50
       8      15 2440290 34132542  20.51
      16      31   12777  383828   0.23
      32      63    9885  502245   0.30
      64     127    6000  556288   0.33
     128     255    2028  403909   0.24
     256     511    1200  482957   0.29
     512    1023     716  636682   0.38
    8192   16383       1   10721   0.01
   16384   32767       3   91708   0.06
   32768   65535       8  511531   0.31
   65536  131071       4  466691   0.28
  131072  262143       2  399959   0.24
  262144  524287       1  424060   0.25
  524288 1048575       2 1576024   0.95
67108864 134217727       1 124742750  74.96
total free extents 2763426
total free blocks 166419165
average free extent size 60.222

agno: 5

    from      to extents  blocks    pct
       1       1   62798   62798   0.04
       2       3   86018  211796   0.13
       4       7  155179  861637   0.51
       8      15 2461646 34419704  20.38
      16      31    8211  242995   0.14
      32      63    6147  312728   0.19
      64     127    4060  377756   0.22
     128     255    1639  324857   0.19
     256     511    1066  426459   0.25
     512    1023     628  551270   0.33
    1024    2047      21   42640   0.03
    4096    8191      19  154751   0.09
    8192   16383       3   48246   0.03
   16384   32767      36 1001272   0.59
   32768   65535      22 1353134   0.80
   65536  131071       9  997297   0.59
  131072  262143       5  956454   0.57
  262144  524287       2  791273   0.47
67108864 134217727       1 125713449  74.45
total free extents 2787510
total free blocks 168850516
average free extent size 60.574

agno: 6

    from      to extents  blocks    pct
       1       1   63996   63996   0.04
       2       3   86207  211968   0.13
       4       7  155967  866727   0.53
       8      15 2463571 34439233  21.06
      16      31    3157   95678   0.06
      32      63    2610  136346   0.08
      64     127    2457  230355   0.14
     128     255    1047  209774   0.13
     256     511     910  371804   0.23
     512    1023     337  299444   0.18
   16384   32767       1   26426   0.02
   32768   65535      36 2269828   1.39
   65536  131071       8  888234   0.54
  131072  262143       4  840290   0.51
67108864 134217727       1 122580715  74.96
total free extents 2780309
total free blocks 163530818
average free extent size 58.8175

agno: 7

    from      to extents  blocks    pct
       1       1   57968   57968   0.04
       2       3   81392  200291   0.12
       4       7  150633  838511   0.51
       8      15 2452592 34308186  21.04
      16      31   10556  313049   0.19
      32      63    8025  407351   0.25
      64     127    5221  485511   0.30
     128     255    1931  381034   0.23
     256     511    1274  508325   0.31
     512    1023     564  489032   0.30
    1024    2047      10   18520   0.01
    2048    4095      10   38983   0.02
   16384   32767      10  304146   0.19
   32768   65535      45 2850896   1.75
   65536  131071      17 1842015   1.13
  131072  262143       6 1246414   0.76
  262144  524287       1  262145   0.16
67108864 134217727       1 118542048  72.68
total free extents 2770256
total free blocks 163094425
average free extent size 58.8734

agno: 8

    from      to extents  blocks    pct
       1       1   62163   62163   0.04
       2       3   85714  210633   0.12
       4       7  155867  866387   0.50
       8      15 2487324 34785498  19.92
      16      31    7746  230123   0.13
      32      63    5837  297084   0.17
      64     127    3823  355612   0.20
     128     255    1267  251642   0.14
     256     511     669  263765   0.15
     512    1023     498  422441   0.24
    1024    2047      76  149774   0.09
    2048    4095       1    2983   0.00
    8192   16383      20  314142   0.18
   16384   32767      53 1488559   0.85
   32768   65535      23 1439056   0.82
   65536  131071      11 1148985   0.66
  131072  262143      10 2436603   1.40
  262144  524287       5 2132760   1.22
  524288 1048575       1  888836   0.51
2097152 4194303       2 6020693   3.45
67108864 134217727       1 120832045  69.21
total free extents 2811111
total free blocks 174599784
average free extent size 62.1106

agno: 9

    from      to extents  blocks    pct
       1       1   65250   65250   0.04
       2       3   86309  211892   0.12
       4       7  155874  866147   0.50
       8      15 2474275 34589732  19.85
      16      31    4047  122150   0.07
      32      63    3229  170318   0.10
      64     127    2776  259801   0.15
     128     255     900  184136   0.11
     256     511     503  206122   0.12
     512    1023     338  298228   0.17
    1024    2047      22   44491   0.03
    8192   16383       1   13987   0.01
   32768   65535       8  449210   0.26
   65536  131071       4  462016   0.27
  131072  262143       4  751654   0.43
  262144  524287       1  454894   0.26
  524288 1048575       2 1059198   0.61
67108864 134217727       1 134047511  76.93
total free extents 2793544
total free blocks 174256737
average free extent size 62.3784

agno: 10

    from      to extents  blocks    pct
       1       1   58416   58416   0.04
       2       3   82628  203152   0.12
       4       7  151621  843085   0.51
       8      15 2438528 34100460  20.69
      16      31    7121  212563   0.13
      32      63    5588  285927   0.17
      64     127    3653  342148   0.21
     128     255    1510  297523   0.18
     256     511    1071  429777   0.26
     512    1023     552  479178   0.29
   65536  131071      14 1711543   1.04
67108864 134217727       1 125826734  76.36
total free extents 2750703
total free blocks 164790506
average free extent size 59.9085

agno: 11

    from      to extents  blocks    pct
       1       1   63413   63413   0.04
       2       3   85787  210999   0.12
       4       7  154926  861215   0.50
       8      15 2467056 34493555  20.04
      16      31    6112  180299   0.10
      32      63    4595  232652   0.14
      64     127    3048  283999   0.16
     128     255    1273  251008   0.15
     256     511     617  246739   0.14
     512    1023     459  401771   0.23
    1024    2047      21   40988   0.02
   16384   32767       1   17100   0.01
   32768   65535      11  708819   0.41
   65536  131071      10 1156028   0.67
  131072  262143       2  380522   0.22
  262144  524287       2  705793   0.41
  524288 1048575       1  766965   0.45
67108864 134217727       1 131155705  76.18
total free extents 2787335
total free blocks 172157570
average free extent size 61.7642

agno: 12

    from      to extents  blocks    pct
       1       1   63088   63088   0.04
       2       3   85493  209933   0.12
       4       7  155808  865433   0.51
       8      15 2457983 34364055  20.14
      16      31    3311   99958   0.06
      32      63    2864  151019   0.09
      64     127    2574  241307   0.14
     128     255    1150  233390   0.14
     256     511     849  350944   0.21
     512    1023     275  248570   0.15
    1024    2047      16   31485   0.02
   16384   32767       1   17400   0.01
   32768   65535      35 2164516   1.27
   65536  131071       1  109651   0.06
67108864 134217727       1 131494733  77.06
total free extents 2773449
total free blocks 170645482
average free extent size 61.5283

agno: 13

    from      to extents  blocks    pct
       1       1   58214   58214   0.04
       2       3   82065  201828   0.13
       4       7  150877  839331   0.55
       8      15 2438076 34112592  22.48
      16      31    8210  243117   0.16
      32      63    6212  314738   0.21
      64     127    4233  392768   0.26
     128     255    1798  354387   0.23
     256     511    1159  465769   0.31
     512    1023     357  316807   0.21
    1024    2047       1    1027   0.00
    8192   16383       1   12729   0.01
   16384   32767       6  194438   0.13
   32768   65535       6  363076   0.24
   65536  131071      19 2217537   1.46
  262144  524287       6 2765012   1.82
  524288 1048575       1  746954   0.49
67108864 134217727       1 108136239  71.27
total free extents 2751242
total free blocks 151736563
average free extent size 55.152

agno: 14

    from      to extents  blocks    pct
       1       1   61503   61503   0.04
       2       3   84497  207953   0.12
       4       7  154082  856792   0.49
       8      15 2465147 34481897  19.79
      16      31    8910  262871   0.15
      32      63    6719  339194   0.19
      64     127    4438  412756   0.24
     128     255    1693  333534   0.19
     256     511    1250  498360   0.29
     512    1023     566  492890   0.28
    4096    8191      12   97908   0.06
    8192   16383       4   60398   0.03
   16384   32767      20  620632   0.36
   32768   65535      10  605977   0.35
   65536  131071      11 1410553   0.81
2097152 4194303       1 2182350   1.25
67108864 134217727       1 131294582  75.36
total free extents 2788864
total free blocks 174220150
average free extent size 62.4699

agno: 15

    from      to extents  blocks    pct
       1       1   65000   65000   0.04
       2       3   86709  212981   0.13
       4       7  156011  866383   0.54
       8      15 2466844 34492253  21.44
      16      31    5974  180556   0.11
      32      63    4649  240943   0.15
      64     127    3468  322600   0.20
     128     255    1236  249791   0.16
     256     511     679  277236   0.17
     512    1023     459  403318   0.25
    1024    2047       8   14639   0.01
    2048    4095       1    2807   0.00
    4096    8191       1    6307   0.00
    8192   16383       2   32734   0.02
   16384   32767       7  218413   0.14
   32768   65535       8  449137   0.28
   65536  131071       2  242135   0.15
  131072  262143       7 1713859   1.07
  262144  524287       1  382825   0.24
67108864 134217727       1 120507166  74.90
total free extents 2791067
total free blocks 160881083
average free extent size 57.6414

agno: 16

    from      to extents  blocks    pct
       1       1   59995   59995   0.04
       2       3   84021  206593   0.13
       4       7  153092  851253   0.53
       8      15 2445986 34205258  21.35
      16      31    7706  230011   0.14
      32      63    5847  296895   0.19
      64     127    3671  342511   0.21
     128     255    1386  276665   0.17
     256     511    1047  418400   0.26
     512    1023     444  393569   0.25
    2048    4095       1    3836   0.00
    8192   16383      57  923920   0.58
   16384   32767       9  277395   0.17
   32768   65535      14  872131   0.54
   65536  131071       4  453752   0.28
  131072  262143       2  516239   0.32
67108864 134217727       1 119849159  74.82
total free extents 2763283
total free blocks 160177582
average free extent size 57.9664

agno: 17

    from      to extents  blocks    pct
       1       1   62064   62064   0.04
       2       3   84894  208678   0.12
       4       7  152464  847945   0.49
       8      15 2436154 34060275  19.60
      16      31    6896  203819   0.12
      32      63    5037  255213   0.15
      64     127    3347  311748   0.18
     128     255    1386  272353   0.16
     256     511    1061  426104   0.25
     512    1023     251  225433   0.13
    1024    2047      12   23466   0.01
   16384   32767      25  765556   0.44
   32768   65535      13  824471   0.47
   65536  131071      16 1783880   1.03
  131072  262143       1  262109   0.15
  524288 1048575       1  980243   0.56
67108864 134217727       1 132228616  76.11
total free extents 2753623
total free blocks 173741973
average free extent size 63.0958

agno: 18

    from      to extents  blocks    pct
       1       1   63510   63510   0.04
       2       3   86590  212743   0.13
       4       7  155400  862806   0.52
       8      15 2438373 34082653  20.59
      16      31    7471  225319   0.14
      32      63    5620  290203   0.18
      64     127    3958  367844   0.22
     128     255    1621  322271   0.19
     256     511    1095  446779   0.27
     512    1023     558  487424   0.29
    1024    2047      17   31533   0.02
    2048    4095      56  227063   0.14
    4096    8191       9   73533   0.04
    8192   16383       1   16113   0.01
   16384   32767      17  522598   0.32
   32768   65535      33 1840782   1.11
   65536  131071      15 1503525   0.91
  131072  262143       3  574064   0.35
67108864 134217727       1 123391119  74.54
total free extents 2764348
total free blocks 165541882
average free extent size 59.8846

agno: 19

    from      to extents  blocks    pct
       1       1   61421   61421   0.04
       2       3   84987  208880   0.13
       4       7  153425  852448   0.53
       8      15 2435860 34057838  21.01
      16      31    7082  210536   0.13
      32      63    5294  271276   0.17
      64     127    3624  336487   0.21
     128     255    1382  272505   0.17
     256     511     891  364079   0.22
     512    1023     508  438421   0.27
    1024    2047      42   82089   0.05
    2048    4095       4   14924   0.01
    4096    8191      32  256863   0.16
    8192   16383       9  138127   0.09
   16384   32767      24  731361   0.45
   32768   65535      27 1655286   1.02
   65536  131071       7  754714   0.47
  131072  262143      17 3955403   2.44
  262144  524287       1  281714   0.17
67108864 134217727       1 117189478  72.28
total free extents 2754638
total free blocks 162133850
average free extent size 58.8585


xfs_db -r -c "frag" /dev/sda5
actual 81347252, ideal 80737778, fragmentation factor 0.75%

df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda3            1008M  225M  733M  24% /
/dev/sda1             124M   26M   92M  22% /boot
/dev/sda4             4.0G  1.0G  2.8G  27% /usr
/dev/sda5              20T  7.2T   13T  36% /var

df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sda3              65536    4972   60564    8% /
/dev/sda1              32768      38   32730    1% /boot
/dev/sda4             262144   15611  246533    6% /usr
/dev/sda5            4294907072 90903011 4204004061    3% /var


Linas

On 11/13/2012 12:36 AM, Dave Chinner wrote:
> On Mon, Nov 12, 2012 at 03:58:15PM +0200, Linas Jankauskas wrote:
>> Hi,
>>
>> /dev is automaticaly mounted by automount and it is always equal to
>> half physical memory.
>
> Is it? It's not on my RHEL6.3 boxes - it's got a 10MB udev
> filesystem mounted on /dev. Anyway, irrelelvant.
>
>> RAID geometry:
>>   Logical Drive: 1
>>           Size: 20.0 TB
>>           Fault Tolerance: RAID 5
> ...
>>           Strip Size: 64 KB
>
> Ok, so su=16, sw=11.
>
>> Here is output of perf top:
>>
>> 18.42%  [kernel]            [k] _spin_lock
>>   16.07%  [xfs]               [k] xfs_alloc_busy_trim
>
> Whoa, really?
>
>>   10.46%  [xfs]               [k] xfs_alloc_get_rec
>>    9.46%  [xfs]               [k] xfs_btree_get_rec
>>    8.38%  [xfs]               [k] xfs_btree_increment
>>    8.31%  [xfs]               [k] xfs_alloc_ag_vextent_near
>>    6.82%  [xfs]               [k] xfs_btree_get_block
>>    5.72%  [xfs]               [k] xfs_alloc_compute_aligned
>>    4.01%  [xfs]               [k] xfs_btree_readahead
>>    3.53%  [xfs]               [k] xfs_btree_rec_offset
>>    2.92%  [xfs]               [k] xfs_btree_rec_addr
>>    1.30%  [xfs]               [k] _xfs_buf_find
>
> This looks like allocation of extents, not freeing of extents. Can
> you attach the entire output?
>
>> strace of rsync process:
>>
>> % time     seconds  usecs/call     calls    errors syscall
>> ------ ----------- ----------- --------- --------- ----------------
>>   99.99   18.362863      165431       111           ftruncate
>
> Which means this must be *extending* files. But an strace is not
> what I need right now - the event trace via trace-cmd is what I need
> to determine exactly what is happening.  Five seconds of tracing
> output while this problem is happening is probably going to be
> sufficient.
>
> What I'd really like to know is what type of files you are rsyncing
> to this box. can you post your typical rsync command? Are you
> rsyncing over the top of existing files, or new copies? How big are
> the files? are tehy sparse? what's a typical xfs_bmap -vp output on
> one of these files that has taken this long to ftruncate?
>
> Further, I need to know what free space looks like in your
> filesystem. the output of something like:
>
> for i in `seq 0 1 19`; do
> 	echo -s "\nagno: $i\n"
> 	xfs_db -r -c "freesp -s -a $i" /dev/sda5
> done
>
> and this:
>
> xfs_db -r -c "frag" /dev/sda5
>
> While give an indication of the state of freespace in the
> filesystem.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
