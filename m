Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:33:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3A0XCC9027010
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:33:13 -0700
Received: from smtp.getmail.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69A45770C9C
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 17:33:48 -0700 (PDT)
Received: from smtp.getmail.no (smtp.getmail.no [84.208.20.33]) by cuda.sgi.com with ESMTP id pOlN4f95XXIBUHKX for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 17:33:48 -0700 (PDT)
Received: from pmxchannel-daemon.no-osl-m323-srv-004-z2.isp.get.no by
 no-osl-m323-srv-004-z2.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 id <0JZ200M3DUIFIV00@no-osl-m323-srv-004-z2.isp.get.no> for xfs@oss.sgi.com;
 Wed, 09 Apr 2008 23:32:39 +0200 (CEST)
Received: from smtp.getmail.no ([10.5.16.1])
 by no-osl-m323-srv-004-z2.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with ESMTP id <0JZ200MM2UIARIA0@no-osl-m323-srv-004-z2.isp.get.no> for
 xfs@oss.sgi.com; Wed, 09 Apr 2008 23:32:34 +0200 (CEST)
Received: from localhost ([84.215.109.218])
 by no-osl-m323-srv-009-z1.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with ESMTP id <0JZ2001YHUIAWD10@no-osl-m323-srv-009-z1.isp.get.no> for
 xfs@oss.sgi.com; Wed, 09 Apr 2008 23:32:34 +0200 (CEST)
Date: Wed, 09 Apr 2008 23:32:34 +0200
From: Thor Kristoffersen <thorkr@gmail.com>
Subject: Re: [patch] Re: Does XFS prevent disk spindown?
In-reply-to: <20080409041113.GC108924158@sgi.com>
Message-id: <m21w5eiuj1.fsf@getmail.no>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <m2tzimbvif.fsf@getmail.no> <20080401003005.GJ103491721@sgi.com>
 <47F1CF6D.2040103@sandeen.net> <m2d4p9o2sc.fsf@getmail.no>
 <m2y77smmdj.fsf@getmail.no> <47F9735E.8020900@sgi.com>
 <m2wsn9qub4.fsf@getmail.no> <20080407215855.GE108924158@sgi.com>
 <m2skxwriye.fsf@getmail.no> <20080409041113.GC108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

David Chinner <dgc@sgi.com> writes:
> On Tue, Apr 08, 2008 at 07:53:13AM +0200, Thor Kristoffersen wrote:
>> David Chinner <dgc@sgi.com> writes:
>> >> > What does 'xfs_logprint -t' show in these "idle" states
>> >> > after these writes?
>> >> 
>> >> xfs_logprint produces output like the one shown below, so it does indeed
>> >> look like it's writing to the journal.  But why should it need to keep
>> >> writing to the journal when there have been no updates to any files on that
>> >> partition recently?
>> >
>> > Are you using lazy-count=1? (i.e. output of 'xfs_info <mtpt>', please).
>> 
>> Looks like I am:
>> 
>> meta-data=/dev/sda3              isize=256    agcount=4, agsize=42676171 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=170704681, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096  
>> log      =internal               bsize=4096   blocks=32768, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> 
>> Is that what's causing it?  I have never specified any lazy-count option
>> when I created or mounted the filesystem.  I didn't even know it existed.
>
> Introduced in 2.6.22, and recently was made the default mkfs config.
>
> Try the patch below.

Thanks a lot, David!  Your patch worked perfectly.  Also thanks to the
others who helped me track down this issue.

BTW, what are the consequences of setting lazy-count to 0?  Less safety?
Reduced performance?


Thor
