Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 19:08:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5227uTd018505
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 19:08:00 -0700
Message-ID: <4843562A.9030503@sgi.com>
Date: Mon, 02 Jun 2008 12:08:42 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net>	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>	 <483F907A.3020108@sgi.com> <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com>
In-Reply-To: <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Spam Magnet wrote:
>> As Eric said.
>> We chose the ondisk format to have the byte ordering of IRIX so
>> it should not be a problem. However, parts of the log code in Linux
>> does not do the necessary endian conversion (due to lack of info at
>> the relevant points - it only knows as blobs of data) and so you
>> need the log to be clean. i.e. byte ordering problem just for the log.
>>
> 
> Thanks for this info, it's good to have 1 less problem to worry about :)
> 
>> OOI, as Eric asked, how were you able to mount it all of a sudden?
>>
> 
> I am not sure, as I said, to narrow down the problem I am experiencing
> with other disks, I decided to format an empty, healthy disk under Irix and
> try to mount it under Linux. The first try was not successful but the
> second was.
> 
> Right now I am making an image of the good/healthy disk using dd to
> see if I can mount that
> image under Linux. (It's not fun to copy 2GB disks through a
> USB1.1-SCSI adapter :)

:-)
If the fs is not too full then xfs_copy would be good I suppose as
it won't copy freespace.

--Tim
