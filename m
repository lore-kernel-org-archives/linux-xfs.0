Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 22:27:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U5Rghf019631
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 22:27:44 -0700
Message-ID: <483F907A.3020108@sgi.com>
Date: Fri, 30 May 2008 15:28:26 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net> <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
In-Reply-To: <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Spam Magnet wrote:
>> try xfs_repair -n then maybe.  Or update xfsprogs.  check shouldn't
>> segfault, regardless of the fs state.
>>
> 
> I updated xfsprogs to the latest version (cvs checkout) and it solved
> the segfault.
> 
>> nah that's fine, images or disks, whichever.
>>
> 
> So I guess it doesn't matter if I do the image either using dd or xfsdump.

xfsdump won't give you an image.
xfsdump has its own format (with a bunch of overhead) which can just
be read by xfsrestore. And restore then just writes out the files
using mostly standard posix calls.
You'll want dd or xfs_copy if you want it as an image.

>> ----- partitions -----
>> >> Pt#    Device  Info     Start       End   Sectors  Id  System
>> >>  8: /dev/sdb1               2      1021   2087936   a  SGI xfs
>> >>  9: /dev/sdb2               0         1      3072   0  SGI volhdr
>> >> 11: /dev/sdb3               0      1021   2091008   6  SGI volume
>>
Certainly partition 8 here.
You can tell by the name (System) and the sizes.
The SGI Volume is for the whole volume including the hdr and the
filesystem and the SGI volhdr has the partition info.

> So can this be related to the byte ordering or any of the other
>> issues mentioned in the FAQ regarding xfs under Linux ?
As Eric said.
We chose the ondisk format to have the byte ordering of IRIX so
it should not be a problem. However, parts of the log code in Linux
does not do the necessary endian conversion (due to lack of info at
the relevant points - it only knows as blobs of data) and so you
need the log to be clean. i.e. byte ordering problem just for the log.

OOI, as Eric asked, how were you able to mount it all of a sudden?

--Tim
