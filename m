Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GMPjaQ182284
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 17:25:45 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8A6530405F
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 15:26:06 -0700 (PDT)
Message-Id: <A4183AB1-555D-4218-8154-E37C2AA5860C@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS Preallocate using ALLOCSP
Date: Tue, 16 Jun 2009 17:26:06 -0500
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
	<4A37B744.9030301@sandeen.net>
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
	<B7C1A222-58C5-4858-80B4-F871BF088DB1@sgi.com>
	<8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Smit Shah <getsmit@gmail.com>
Cc: linux-xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>


On Jun 16, 2009, at 4:42 PM, Smit Shah wrote:

> On 6/16/09, Felix Blyakher <felixb@sgi.com> wrote:
>>
>> On Jun 16, 2009, at 12:28 PM, Smit Shah wrote:
>>> but the write performance is going to suffer.
>>
>> It's not clear why it should. Not doing preallocation doesn't
>> mean that there is no inode updates with every write. Why
>> would extent conversion be more expensive that creating the
>> space (extent) and updating the inode size for every write?
>> It'd interesting to reproduce your results. Any details on
>> your tests and the iometer usage?
>
> Since fallocate uses the RESVSP cmd for xfs. And as given given for
> RESVSP in man page for xfsctl
> If the  XFS filesystem  is  configured to flag unwritten file extents,

Good point, we should update the man page, there is no 'if'
any more.

>
> performance will be negatively affected when writing to preallocated
> space, since extra filesystem transactions are required to convert
> extent  flags  on  the  range  of  the  file  written.

Yes, absolutely, there is overhead to handle unwritten
extents, no doubt. My remark was wrt comparison between
not doing preallocation at all and preallocation with
unwritten extents. Both cases would incur the metadata
updates with every write. And I doubt that write performance
would suffer more in the preallocation case.
Though, if you prefer to trade extra time spent at every
write to setup time, you can/should manually fill the
file with zeros.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
