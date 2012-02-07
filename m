Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17HfFTw248009 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 11:41:16 -0600
Received: from nm3-vm0.bt.bullet.mail.ird.yahoo.com
	(nm3-vm0.bt.bullet.mail.ird.yahoo.com [212.82.108.88]) by
	cuda.sgi.com with SMTP id nSGftRFI98BRCGzw for
	<xfs@oss.sgi.com>; Tue, 07 Feb 2012 09:41:13 -0800 (PST)
Message-ID: <4F316236.7050607@rhul.ac.uk>
Date: Tue, 07 Feb 2012 17:41:10 +0000
From: Tom Crane <T.Crane@rhul.ac.uk>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults with ag_stride option
References: <4F293FCC.7010101@rhul.ac.uk>
	<20120202124248.GA12107@infradead.org>
	<4F2F23F3.9000402@rhul.ac.uk> <4F2F6C00.5050108@sandeen.net>
	<4F2FB72B.9010209@rhul.ac.uk> <4F2FD3DC.3030301@sandeen.net>
In-Reply-To: <4F2FD3DC.3030301@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, "T.Crane >> Crane T" <T.Crane@rhul.ac.uk>, xfs@oss.sgi.com

Eric Sandeen wrote:
> On 2/6/12 5:19 AM, Tom Crane wrote:
>   
>> Eric Sandeen wrote:
>>     
>
> ...
>
>   
>>> Newer tools are fine to use on older filesystems, there should be no
>>>   
>>>       
>> Good!
>>
>>     
>>> issue there.
>>>
>>> running fsr can cause an awful lot of IO, and a lot of file reorganization.
>>> (meaning, they will get moved to new locations on disk, etc).
>>>
>>> How bad is it, really?  How did you arrive at the 40% number?  Unless
>>>   
>>>       
>> xfs_db -c frag -r <block device>
>>     
>
> which does:
>
>                 answer = (double)(extcount_actual - extcount_ideal) * 100.0 /
>                          (double)extcount_actual;
>
> If you work it out, if every file was split into only 2 extents, you'd have
> "50%" - and really, that's not bad.  40% is even less bad.
>   

Here is a list of some of the more fragmented files, produced using,
xfs_db -r /dev/mapper/vg0-lvol0 -c "frag -v" | head -1000000 | sort 
-k4,4 -g | tail -100

> inode 1323681 actual 12496 ideal 2
> inode 1324463 actual 12633 ideal 2
> inode 1333841 actual 12709 ideal 2
> inode 1336378 actual 12816 ideal 2
> inode 1321872 actual 12845 ideal 2
> inode 1326336 actual 13023 ideal 2
> inode 1334204 actual 13079 ideal 2
> inode 1318894 actual 13151 ideal 2
> inode 1339200 actual 13179 ideal 2
> inode 1106019 actual 13264 ideal 2
> inode 1330156 actual 13357 ideal 2
> inode 1325766 actual 13482 ideal 2
> inode 1322262 actual 13537 ideal 2
> inode 1321605 actual 13572 ideal 2
> inode 1333068 actual 13897 ideal 2
> inode 1325224 actual 14060 ideal 2
> inode 48166 actual 14167 ideal 2
> inode 1319965 actual 14187 ideal 2
> inode 1334519 actual 14212 ideal 2
> inode 1327312 actual 14264 ideal 2
> inode 1322761 actual 14724 ideal 2
> inode 425483 actual 14761 ideal 2
> inode 1337466 actual 15024 ideal 2
> inode 1324853 actual 15039 ideal 2
> inode 1327964 actual 15047 ideal 2
> inode 1334036 actual 15508 ideal 2
> inode 1329861 actual 15589 ideal 2
> inode 1324306 actual 15665 ideal 2
> inode 1338957 actual 15830 ideal 2
> inode 1322943 actual 16385 ideal 2
> inode 1321074 actual 16624 ideal 2
> inode 1323162 actual 16724 ideal 2
> inode 1318543 actual 16734 ideal 2
> inode 1340193 actual 16756 ideal 2
> inode 1334354 actual 16948 ideal 2
> inode 1324121 actual 17057 ideal 2
> inode 1326106 actual 17318 ideal 2
> inode 1325527 actual 17425 ideal 2
> inode 1332902 actual 17477 ideal 2
> inode 1330358 actual 18775 ideal 2
> inode 1338161 actual 18858 ideal 2
> inode 1320625 actual 20579 ideal 2
> inode 1335016 actual 22701 ideal 2
> inode 753185 actual 33483 ideal 2
> inode 64515 actual 37764 ideal 2
> inode 76068 actual 41394 ideal 2
> inode 76069 actual 65898 ideal 2

The following for some of the larger, more fragmented files was produced 
by parsing/summarising the output of bmap -l

> (nos-extents size-of-smallest-extent size-of-largest-extent 
> size-of-average-extent)
> 20996 8 38232 370.678986473614
> 21831 8 1527168 555.59158994091
> 22700 8 407160 371.346607929515
> 26075 8 1170120 544.218753595398
> 27632 16 480976 311.79473074696
> 29312 8 184376 348.09115720524
> 29474 8 1632 8.06758499016082
> 33482 16 421008 292.340959321426
> 34953 8 457848 371.310044917461
> 37763 8 82184 377.083812197124
> 37826 8 970624 314.246497118384
> 39892 16 508936 345.970921488018
> 41393 8 214496 443.351291281134
> 47877 8 1047728 325.400004177371
> 50562 8 677576 328.302994343578
> 53743 8 672896 364.316841263048
> 54378 16 764280 360.091801831623
> 59071 8 910816 332.138748285961
> 62666 8 337808 312.538601474484
> 65897 16 775832 287.113040047347
> 84946 8 1457120 496.702563981824
> 117798 8 161576 53.8408461943327
> 119904 8 39048 168.37943688284
> 131330 8 65424 68.948267722531
> 174379 8 1187616 112.254113167297
> 254070 8 1418960 303.413201086315
> 313029 8 280064 62.6561756259005
> 365547 8 76864 53.5732368204362
> 1790382 8 1758176 359.880034540115
> 2912436 8 1004848 373.771190851919
 How bad does this look?

Cheers
Tom.


>> Some users on our compute farm with large jobs (lots of I/O) find they take longer than with some of our other scratch arrays hosted on other machines.  We also typically find many nfsd tasks in an uninterruptible wait state (sync_page), waiting for data to be copied in from the FS.
>>     
>
> So fragmentation may not be the problem... 
>
> -Eric
>
>   
>>> you see perf problems which you know you can attribute to fragmentation,
>>> I might not worry about it.
>>>
>>> You can also check the fragmentation of individual files with the
>>> xfs_bmap tool.
>>>
>>> -Eric
>>>   
>>>       
>> Thanks for your advice.
>> Cheers
>> Tom.
>>
>>     
>>>  
>>>       
>>>> Tom.
>>>>
>>>> Christoph Hellwig wrote:
>>>>    
>>>>         
>>>>> Hi Tom,
>>>>>
>>>>> On Wed, Feb 01, 2012 at 01:36:12PM +0000, Tom Crane wrote:
>>>>>  
>>>>>      
>>>>>           
>>>>>> Dear XFS Support,
>>>>>>    I am attempting to use xfs_repair to fix a damaged FS but always
>>>>>> get a segfault if and only if -o ag_stride is specified. I have
>>>>>> tried ag_stride=2,8,16 & 32.  The FS is approx 60T. I can't find
>>>>>> reports of this particular problem on the mailing list archive.
>>>>>> Further details are;
>>>>>>
>>>>>> xfs_repair version 3.1.7, recently downloaded via git repository.
>>>>>> uname -a
>>>>>> Linux store3 2.6.18-274.17.1.el5 #1 SMP Wed Jan 11 11:10:32 CET 2012
>>>>>> x86_64 x86_64 x86_64 GNU/Linux
>>>>>>             
>>>>>>             
>>>>> Thanks for the detailed bug report.
>>>>>
>>>>> Can you please try the attached patch?
>>>>>
>>>>>         
>>>>>           
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>     
>>>>         
>>>   
>>>       
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
