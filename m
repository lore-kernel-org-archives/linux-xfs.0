Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4DACF7F99
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 12:25:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CB44304043
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 10:25:36 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id 7n8OAAOdMInb6cBg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Mar 2014 10:25:34 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id B6A6C30823
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 18:25:32 +0100 (CET)
MIME-Version: 1.0
Date: Mon, 17 Mar 2014 18:25:32 +0100
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: Re: elevator question
In-Reply-To: <CAFLt3pg256f7iNnYtZVu6dfQ=Z5rq3Aum_zWjGk571fHA4By-w@mail.gmail.com>
References: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
	<CAFLt3pg256f7iNnYtZVu6dfQ=Z5rq3Aum_zWjGk571fHA4By-w@mail.gmail.com>
Message-ID: <c9ab54d1b0462d58dcf0b8c8da768244@zbfmail.de>
Reply-To: weber@zbfmail.de
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>



Am 2014-03-17 16:39, schrieb Grozdan:
> On Mon, Mar 17, 2014 at 4:35 PM, Marko Weber|8000 <weber@zbfmail.de> 
> wrote:
>> 
>> hello list,
>> in the xfs faq i read elevator=noop is best when using ssd.
>> i have the gentoo system on a ssd, but the larger data storage 
>> partition on
>> softraid with some sata disks.
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
>> Mailfiltering, SMTP Service, Spam Abwehr, MX-Backup, Mailserver Backup
>> Redundante Mailgateways, HA Mailserver, Secure Mailserver
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
