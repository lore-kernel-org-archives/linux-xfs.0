Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8EBE97F9C
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 12:38:33 -0500 (CDT)
From: Shaun Gosse <sgosse@sgi.com>
Subject: RE: elevator question
Date: Mon, 17 Mar 2014 17:38:32 +0000
Message-ID: <8D3FA7645C1CFC4E9E783D22B4C708647306B0F7@P-EXMB2-DC21.corp.sgi.com>
References: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
	<CAFLt3pg256f7iNnYtZVu6dfQ=Z5rq3Aum_zWjGk571fHA4By-w@mail.gmail.com>
	<c9ab54d1b0462d58dcf0b8c8da768244@zbfmail.de>
In-Reply-To: <c9ab54d1b0462d58dcf0b8c8da768244@zbfmail.de>
Content-Language: en-US
MIME-Version: 1.0
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
To: "weber@zbfmail.de" <weber@zbfmail.de>, Xfs <xfs@oss.sgi.com>

Marko,

I haven't done this myself, so use at your own risk, but from the archlinux wiki, there's an example of using udev to set one scheduler for non-rotational disks and another for rotational, which sounds like a good general solution for what you're looking for here:

https://wiki.archlinux.org/index.php/Solid_State_Drives#Using_udev_for_one_device_or_HDD.2FSSD_mixed_environment 

Cheers,
-Shaun

-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Marko Weber|8000
Sent: Monday, March 17, 2014 12:26 PM
To: Xfs
Subject: Re: elevator question



Am 2014-03-17 16:39, schrieb Grozdan:
> On Mon, Mar 17, 2014 at 4:35 PM, Marko Weber|8000 <weber@zbfmail.de>
> wrote:
>> 
>> hello list,
>> in the xfs faq i read elevator=noop is best when using ssd.
>> i have the gentoo system on a ssd, but the larger data storage 
>> partition on softraid with some sata disks.
>> is elevator=noop in this combo still best?
>> 
>> thx for any cunstructive answer
>> 
>> marko
> 
> noop and deadline are best for SSDs. deadline is best for spinning 
> disks with XFS, especially in RAID. Stay away from CFQ as it kills 
> parallelism in XFS

thx grozdan,
but what, if i have mixed setup in a server ssd + sata ??

marko


> 
>> 
>> 
>> 
>> --
>> zbfmail - Mittendrin statt nur Datei!
>> 
>> OpenDKIM, SPF, DSPAM, Greylisting, POSTSCREEN, AMAVIS, Mailgateways 
>> Mailfiltering, SMTP Service, Spam Abwehr, MX-Backup, Mailserver 
>> Backup Redundante Mailgateways, HA Mailserver, Secure Mailserver
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
