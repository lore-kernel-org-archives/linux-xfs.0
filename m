Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GMVle9182567
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 17:31:47 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A57FAC019
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 15:32:09 -0700 (PDT)
Message-Id: <681E4FF8-3059-48AC-B828-82B7B31A61A6@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A38171A.4080500@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS Preallocate using ALLOCSP
Date: Tue, 16 Jun 2009 17:32:08 -0500
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>	
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>	
	<4A37B744.9030301@sandeen.net>	
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>	
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>	
	<B7C1A222-58C5-4858-80B4-F871BF088DB1@sgi.com>
	<8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
	<4A38171A.4080500@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com, Smit Shah <getsmit@gmail.com>


On Jun 16, 2009, at 5:05 PM, Eric Sandeen wrote:

> Smit Shah wrote:
>>
>> Since fallocate uses the RESVSP cmd for xfs. And as given given for
>> RESVSP in man page for xfsctl
>> If the  XFS filesystem  is  configured to flag unwritten file  
>> extents,
>> performance will be negatively affected when writing to preallocated
>> space, since extra filesystem transactions are required to convert
>> extent  flags  on  the  range  of  the  file  written.
>
> And ext4 must do basically the same thing, as would any fs that flags
> unwritten extents.
>
> ext4 may convert more at a time, though, rather than leaving
> "fragmented" written/unwritten/written/unwritten regions.

Converting more at a time would require writing extra zeros
to extra space converted, but not covered with write. Again,
it's a trade off, and there is no clear winner. Well, at least
not in my mind, until proven that some operations are more
efficient than others.

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
