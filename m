Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 19:01:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D2164p000523
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 19:01:08 -0700
Received: from timothy-shimmins-power-mac-g5.local (boing.melbourne.sgi.com [134.14.55.141]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA27844 for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 12:01:07 +1000
Message-ID: <46E899E3.2010808@sgi.com>
Date: Thu, 13 Sep 2007 12:01:07 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: state of the cvs tree
References: <20070912121938.GA16870@lst.de> <46E89542.5040202@sgi.com>
In-Reply-To: <46E89542.5040202@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Timothy Shimmin wrote:
> Hi Christoph,
> 
> Christoph Hellwig wrote:
>> looks like the cvs tree is broken currently - fs/xfs/ is merged up to
>> 2.6.23-rc, but everything else is still at 2.6.22-rc state leading to
>> various compile failures.
>>
> Looking at cvs web it looks like the 2.6.x-xfs was updated 8 hours
> ago. So I am guessing that you saw a state of the tree whilst it
> was doing its sync up.
> Let me know if things are not fine for you still?
> 
> --Tim
> 

Looking at the oss scripts briefly it reminded me of all the trees
involved:
   $s[0]->{"fromdir"} = "$pushroot/p_src/slinx_2.4.x-xfs";
   $s[0]->{"todir"} =   "$pushroot/CVSROOT/slinx_2.4.x-xfs";

   $s[1]->{"fromdir"} = "$pushroot/p_src/slinx_2.6.x-xfs";
   $s[1]->{"todir"} =   "$pushroot/CVSROOT/slinx_2.6.x-xfs";

   $s[2]->{"fromdir"} = "$pushroot/p_src/xfs-cmds";
   $s[2]->{"todir"} =   "$pushroot/tmp/CVSROOT/xfs-cmds";

   $s[3]->{"fromdir"} = "$pushroot/p_src/xfs-linux";
   $s[3]->{"todir"} =   "$pushroot/tmp/CVSROOT/xfs-linux";

   $s[4]->{"fromdir"} = "$pushroot/p_src/dmapi-linux";
   $s[4]->{"todir"} =   "$pushroot/CVSROOT/dmapi";

   $s[5]->{"fromdir"} = "$pushroot/p_src/xfs-website";
   $s[5]->{"todir"} =   "$pushroot/CVSROOT/xfs-website";

The xfs-linux and xfs-dmapi trees are needed for 2.6.x-xfs and 2.4.x-xfs.
I modified xfs-linux, xfs-dmapi, and 2.6.x-xfs as part of the update.

BTW, Donald, we'll have to do something about the 2.4 ptools tree
and cvs sync up if/when 2.4 support is dropped.

--Tim
