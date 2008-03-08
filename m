Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 20:40:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m284eUbi031620
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 20:40:33 -0800
Message-ID: <47D218CF.8090909@sgi.com>
Date: Sat, 08 Mar 2008 15:40:47 +1100
From: Ian Costello <ianc@sgi.com>
Reply-To: ianc@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
References: <47D20F78.7000103@sandeen.net> <47D216A3.9040406@sgi.com> <47D2171D.7070202@sandeen.net>
In-Reply-To: <47D2171D.7070202@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric,

My bad, cxfs uses the sb_uuid, should have looked a little closer at the 
patch. I assumed the worst from the heading (must have filtered the 
"point" out of the heading :)

Eric Sandeen wrote:
> Ian Costello wrote:
>> CXFS does use this to mount filesystems, i.e. on a client read the sb 
>> get the uuid and use the uuid to lookup the MDS to request the mount...
> 
> Well, this isn't removing the sb uuid... it's this special file type
> XFS_DINODE_FMT_UUID... which is cxfs using?
> 
> -Eric
> 
>> Having said that if it is removed then it will force us to look at 
>> another method to mount a cxfs filesystem, and also remove the necessity 
>> for cxfs clients to not read the superblock (which is the only metadata 
>> cxfs clients read off disk at this point)...
>>
>> Regards,
>>
> 
> 

Thanks,

-- 
Ian Costello   Phone: +61 3 9963 1952
R&D Engineer   Mobile: +61 417 508 522
CXFS MultiOS
