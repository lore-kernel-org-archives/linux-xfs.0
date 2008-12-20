Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBKJm25C001580 for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 13:48:03 -0600
Received: from smtp5.clear.net.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 249073AA53
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2008 11:47:58 -0800 (PST)
Received: from smtp5.clear.net.nz (smtp5.clear.net.nz [203.97.33.68]) by
	cuda.sgi.com with ESMTP id U1cKlNExoLVDxI1A for
	<xfs@oss.sgi.com>; Sat, 20 Dec 2008 11:47:58 -0800 (PST)
Received: from kereru.site ([202.0.57.237])
	by smtp5.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0KC60073HXNWUF10@smtp5.clear.net.nz> for xfs@oss.sgi.com;
	Sun, 21 Dec 2008 08:47:57 +1300 (NZDT)
Date: Sun, 21 Dec 2008 08:47:12 +1300
From: Volker Kuhlmann <list0570@paradise.net.nz>
Subject: Re: Intel X25-E running Linux using XFS
In-reply-to: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
Message-id: <20081220194712.GA14015@paradise.net.nz>
MIME-version: 1.0
Content-disposition: inline
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
	<20081212185803.GE11974@elf.ucw.cz>
	<alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Pavel Machek <pavel@suse.cz>, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com

As requested before, please remove mailing list admin addresses
(smartmontools-database-owner@lists.sourceforge.net) from cc. Thanks.


Cc: Pavel Machek <pavel@suse.cz>,
	"cc: smartmontools-support"@lists.sourceforge.net,
	smartmontools-database-owner@lists.sourceforge.net,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, xfs@oss.sgi.com,
	Alan Piszcz <ap@solarrain.com>,
	"X-Mailing-List: linux-raid"@vger.kernel.org
Bcc: 
Subject: Re: Intel X25-E running Linux using XFS
Reply-To: 
In-Reply-To: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>

On Sat 13 Dec 2008 09:23:19 NZDT +1300, Justin Piszcz wrote:

>
>
>
> On Fri, 12 Dec 2008, Pavel Machek wrote:
>
>>
>> Hi!
>>
>>> Due to the 100k write cycle lifetime, I will not be performing any more
>>> benchmarks on the SSD itself, such benchmarks are available on
>>> techreport.com but just wanted to send out the smart data for the
>>> smartmontools list and point out it is working with linux+ich7+xfs.
>>>
>>> Overall, whenever I do anything now its just like the entire machine is
>>> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>>>
>>> The techreport benchmarks are here:
>>> http://techreport.com/articles.x/15931
>>
>> Actually I'd like to know... how does it behave during powerfails
>> while it is being written to?
>>
>> Flashes I seen (USB / SD) developed bad sectors in that case, and
>> ext2/ext3 can't handle that. (And I don't think xfs can handle that
>> either).
>
> I have a UPS for all of my machines, so that will not be a problem in my 
> case.  I do not wish to trash a $720 SSD or my current install, if someone 
> else wants to try feel free though :)
>
> With barriers, presumably it would be safe-- but as always, a UPS/and 
> barriers and/or RAID, there is no excuse not to have regular backups incase 
> of a failure at any time..
>
> I do recall however one instance where there was an apt-get dist-upgrade 
> going and the power was cut to a machine on purpose (before/not using 
> barriers) and suffice to say-- it got mucked/suffered many corruptions
> all over the place.
>
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Volker Kuhlmann			is list0570 with the domain in header
http://volker.dnsalias.net/	Please do not CC list postings to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
