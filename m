Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 02:52:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S9qSQe012105
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:52:28 -0700
Received: from relay.ppgk.com.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FD05550EE6
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:52:27 -0700 (PDT)
Received: from relay.ppgk.com.pl (relay.ppgk.com.pl [80.53.243.36]) by cuda.sgi.com with ESMTP id KKvKYQyeYzCTxheY for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:52:27 -0700 (PDT)
Message-ID: <4906E0BE.8050903@drutsystem.com>
Date: Tue, 28 Oct 2008 10:51:58 +0100
From: Michal Soltys <nozo@drutsystem.com>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed> <4906C164.6090704@aei.mpg.de> <4906D80F.9050500@aei.mpg.de>
In-Reply-To: <4906D80F.9050500@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

Carsten Aulbert wrote:
> 
> Carsten Aulbert wrote:
> 
>> Any idea where my logical error is?
>>
> 
> Related, more logical errors on my side probably:
> 
> Can someone give me a hint what I'm doing wrong here?
> 
> xfs_bmap -l  /local/boinc/time_stats_log
> /local/boinc/time_stats_log:
>         0: [0..127]: 280..407 128 blocks
>         1: [128..159]: 728..759 32 blocks
>         2: [160..167]: 1016..1023 8 blocks
>         3: [168..183]: 54120..54135 16 blocks
>         4: [184..207]: 656..679 24 blocks
>         5: [208..215]: 3451664..3451671 8 blocks
>         6: [216..255]: 3451624..3451663 40 blocks
>         7: [256..287]: 3451672..3451703 32 blocks
> 
>>From that I assume that this file lives in several block strips, when I
> subsequently try to get this back via xfs_db I fail miserably:
> 
> xfs_db -i /dev/sda6
> xfs_db> blockget -b 660 -n
> setting block 0/660 to data
> setting inode to 2787 for block 0/660
> inode 2787 block 660 at offset 346
> xfs_db> ncheck -i 2787
>        2787 CT_oneyear_01/S_noise_wu_84/Fstats_105.25_Snoise__WU84_84_out
> xfs_db> quit
> 
> Is it possible that blocks != bsized_blocks?
> 
> Sorry for these questions, but I'm quite lost and I have not been able
> to find the answer in the man pages.
> 

660 is interpreted (by blockget) using filesystem's block size - so it'd
correspond to 5280 in 512 byte units. That file isn't that long.

Another example:

10:37 > ls -al /music/The\ Flashbulb\ -\ 11\ -\ Remember\ Tomorrow.flac

-rw-r--r-- 1 admin users 21921889 2008-09-08 09:07 /music/The Flashbulb
- 11 - Remember Tomorrow.flac

xfs_bmap -l /music/The\ Flashbulb\ -\ 11\ -\ Remember\ Tomorrow.flac

/music/The Flashbulb - 11 - Remember Tomorrow.flac:
         0: [0..35039]: 12140432..12175471 35040 blocks
         1: [35040..42823]: 12200864..12208647 7784 blocks

Let's check file's sector 36000 - from the perspective of filesystem -
sector 12200864+(36000-35040) = 12201824. Using 4096 block size -
1525228. Now let's check using xfs_db:

10:38 > xfs_db -r /dev/mapper/vg1-music
xfs_db> blockget -b 1525228 -n
setting block 0/1525228 to data
setting inode to 126 for block 0/1525228
inode 126 block 1525228 at offset 4500
sb_fdblocks 1330583, aggregate AGF count 2661166
xfs_db> ncheck -i 126
         126 The Flashbulb - 11 - Remember Tomorrow.flac
