Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84FE07F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:02:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56FC48F8074
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 07:02:44 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	AnUwsEIKipR05ruJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 07:02:37 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id m6so1580654wiv.3
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 07:02:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFcHYYBBfsoxdaxNaRjnfyG3yVrRJYYfuoA5vNurdmu+1AUCyA@mail.gmail.com>
References: <CAFcHYYBBfsoxdaxNaRjnfyG3yVrRJYYfuoA5vNurdmu+1AUCyA@mail.gmail.com>
From: Rafa Griman <rafagriman@gmail.com>
Date: Wed, 17 Apr 2013 16:02:15 +0200
Message-ID: <CANRt_=a91yzfw0f+5ktwUk0w5F4PuM8aWrPA0hONg1i=P2OgWQ@mail.gmail.com>
Subject: Re: Practical file system size question
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi :)

On Wed, Apr 17, 2013 at 3:18 PM, Robert Bennett
<rbennett@mail.crawford.com> wrote:
>
> We have been running our Storage on XFS for over three years now and are
> extremely happy.  We are running each file system on LSI Hardware Raid with
> 3 RAID groups of 12+2 with 3 Hot Spares, and 8 file systems per Head Node.
> These are running on 2TB SAS HDDs.  The individual file system size is 66TB
> in this configuration.  The time has come to look into moving to 3TB SAS
> HDDs.  With very rudimentary math, this should move us to the neighborhood
> of 99TB per file system.  Our OS is linux 2.6.32-279.11.1.el6.x86_64.
>
> The question is - does anyone have experience with this type of
> configuration and in particular with 3TB HDDs and a file system size of
> 99TB?  The rebuild time with 2TB drives is ~ 24 hours.  Should I expect the
> rebuild time for the 3TB drives to be ~ 36 hours?
>
> Thanks for all the hard work all of you do on a file system that continues
> to dazzle.


When you say "LSI Hardware Raid", I assume it's some sort of
NetApp/Engenio storage array (aka E2600, E2400, E5500). Am I correct?
If so, you should try the new their new feature Dynamic Disk Pooling:

http://www.netapp.com/us/system/pdf-reader.aspx?m=ds-3309.pdf&cc=us

http://www.netapp.com/us/technology/dynamic-disk-pools.aspx

It lowers your rebuild times quite a lot.

If you mean internal LSI RAID PCIe controllers in a server ... can't
be of much help here :(

HTH

   Rafa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
