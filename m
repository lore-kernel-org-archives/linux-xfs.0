Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A74F67F5A
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 13:42:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96C398F8040
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:42:43 -0800 (PST)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
	[66.111.4.25]) by cuda.sgi.com with ESMTP id NbjmZcnXZFH1GpcM
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:42:42 -0800 (PST)
Message-ID: <52813330.1020308@itwm.fraunhofer.de>
Date: Mon, 11 Nov 2013 20:42:40 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: ag selection
References: <l5r3tf$m0j$1@ger.gmane.org>	<20131111175313.GA16643@orion.maiolino.org>	<20131111175550.GB16643@orion.maiolino.org>
	<528120B7.9030802@itwm.fraunhofer.de>
	<5281223A.7010503@sandeen.net>
In-Reply-To: <5281223A.7010503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hello Eric,

On 11/11/2013 07:30 PM, Eric Sandeen wrote:
> On 11/11/13, 12:23 PM, Bernd Schubert wrote:
>
>> One of my colleagues benchmarked this on one of our fast systems and another
>> colleague current needs this system for other tests, so I don't have the
>> exact parameters. However, it was for sure formated with options like these:
>>
>> mkfs.xfs -d su=256k,sw=10 -l version=2,su=256k -isize=512 /dev/sdX
>>
>> and mounted with these options:
>>
>> mount -onoatime,nodiratime,largeio,inode64,swalloc,allocsize=131072k,nobarrier /dev/sdX <mountpoint>
>
> With all due respect, this is excessive knob-twiddling.  Slow down.  ;)
>
> * V2 logs are default already, so -l version=2 is redundant.

Well, some of our customer are using fhgfs + xfs on old systems and we 
don't want to create a list

"with kernel/xfsprogs version < xyz, you need knob abc..."

So better add it by default, as long as it does not hurt.

> * noatime implies nodiratime, so specifying both is redundant.

Ok, I didn't add it to our default options, but I also didn't care about 
it.


> * "largeio" only changes the st_blksize value reported (from default page size to, in your case, the total stripe width).  Does that actually affect your application behavior?

Fhgfs does not care about it, but for some backup tools (I think rsync 
does/did? read it) it helps.


>
> Backing up, what kernel & what userspace versions are you testing?

xfsprogs-3.1.1-10.el6 + kernel 3.11.



Cheers,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
