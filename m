Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GLbpHC180071
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 16:37:51 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F13D2FF036
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 14:38:13 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.221.174]) by cuda.sgi.com with ESMTP id
	XCdGsm6ndtasdFTc for <linux-xfs@oss.sgi.com>;
	Tue, 16 Jun 2009 14:38:13 -0700 (PDT)
Received: by qyk4 with SMTP id 4so6333291qyk.20
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 14:38:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A37D737.70004@sandeen.net>
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>
	<4A37B744.9030301@sandeen.net>
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
	<4A37D737.70004@sandeen.net>
Date: Tue, 16 Jun 2009 14:38:12 -0700
Message-ID: <8770d98c0906161438u339440cdm783340485a3db898@mail.gmail.com>
Subject: Re: XFS Preallocate using ALLOCSP
From: Smit Shah <getsmit@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

In the vmware sparse disk,  the chunks are allocated of the size of 64k,
which kindof leads to fragmentation. Hence the sequential read throughput
suffers. So thought it might be a good idea to preallocate some
amount memory say 50Meg when it asks for allocating the chunk thus helps
in reducing fragmentation and improves the throughput.
On linux i do preallocation using fallocate.

I have vmware workstation running Windows Vista and host is RHEL 5.3
with the guest having 1GB of memory and host having 2 Gig. And i have
separate dedicated SATA disk on which i perform the tests. For
testing, I create a new sparse vdisk and run a IOmeter sequential
write on it.

For ext4 i tend to get say around 5-6 Mbps of improvement in write
throughput sometimes but it never goes down. But for XFS i always see
atleast
8-10 Mbps of downfall.

-Smit

On 6/16/09, Eric Sandeen <sandeen@sandeen.net> wrote:
> Smit Shah wrote:
>> On 6/16/09, Felix Blyakher <felixb@sgi.com> wrote:
>>> On Jun 16, 2009, at 10:16 AM, Eric Sandeen wrote:
>
>
>>>> Maybe I should ask what the end goal is here.  :)
>>>>
>> Just to see if preallocation using fallocate helps reducing the
>> fragmentation and increases the throughput.  I guess it wll help
>> reduce the fragmentation but the write performance is going to suffer.
>
> Depends on the IO you do, I think.  I'd be curious to know exactly how
> you're running preallocation & iometer so I could give it a shot, to see
> why xfs seems to be doing worse than ext4.
>


> Thanks,
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
