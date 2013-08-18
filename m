Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6A817F53
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 17:57:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 604E8AC003
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 15:57:17 -0700 (PDT)
Received: from mail-ob0-f176.google.com (mail-ob0-f176.google.com
	[209.85.214.176]) by cuda.sgi.com with ESMTP id
	NVPAqPKeAIEKf4qo (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 15:57:16 -0700 (PDT)
Received: by mail-ob0-f176.google.com with SMTP id uz19so4216823obc.21
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 15:57:15 -0700 (PDT)
Message-ID: <52115146.6070507@gmail.com>
Date: Sun, 18 Aug 2013 18:57:10 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS recovery resumes...
References: <240990.4028.1376863911761.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <240990.4028.1376863911761.JavaMail.root@benjamin.baylink.com>
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
To: xfs@oss.sgi.com

On 08/18/2013 06:11 PM, Jay Ashworth wrote:
> ----- Original Message -----
>> From: "Joe Landman" <joe.landman@gmail.com>
>
>>> You need at least 497MB RAM to run with prefetching enabled.
>>
>> ^^^^^
>>
>> This is 1/2 GB ram, and you didn't specify the memory options of the
>> xfs_repair ... so I'm going to guess at this point that you ran out of
>> ram. Paging while running xfs_repair is no fun.
>>
>> How much ram do you have in this box? Next question is, is this an ECC
>> memory box?
>
> 512M.  It's a *very* old KT6V based board, and when we tried to expand
> it several years back, it went bat-guano with any more than half a gig.

Ahhh .... ok.  Got it.


>
>> Not sure if you are hitting a bug as much as running into something
>> else like a hardware limit (RAM) or a memory stick issue.
>
> Well, the upstream cause was a 7 year old Antec power supply that
> finally died, about a month ago, slowly.

Ok.  I've had power supplies take down memory in the past.  You might be 
hitting a bad memory cell courtesy of the PS.

>
>> Do you have EDAC (or mcelog) on? Any errors from this?
>
> I don't have mcelog on, and no, the memory isn't registered, but a
> 4-pass run of Memtest+ came up clean, so I'm speculating that the

Not registered (which is just buffered), but ECC.  ECC does a parity 
computation on some number of bits, and provides you a rough "good/bad" 
binary state of a particular area of memory.  If the parity bits stored 
don't match what is computed on read, then odds are that something is 
wrong.  Its not foolproof, but its a good mechanism to catch potential 
errors.

We've had cases where Memtest(*) reported everything fine, yet I was 
able to generate ECC errors in a few minutes by running a memory 
intensive app.  Memtest does do some hardware exercise, but its not 
usually hitting memory the way apps do.  That difference can be 
significant.  This is in part why the day job stopped using memtest for 
testing a number of years ago.  We now run heavy duty electronic 
structure codes, and pi/e/... computations for burn in.

> *continuing* problem isn't hardware; I'm pretty sure it was just the
> failing 12V rail on the dying PS.  I just have to clean up after it
> enough to get *one* of these 2 drives cleaned off, then I can make a
> new FS, and play musical files.

Ahhh ...

I was running a Plex server on an old machine for a while.  I had to 
shift over to a beefier box with ECC ram and more CPUs.  Right now my 
Plex server has 8 cpus, 24 GB RAM, and about 1TB of disk (old).  Once 
you start doing recoding on the fly (multi-resolution output), you need 
the ram and processor power.

>
> Or, I may just go grab a 3TB external after all.  :-)

If you do that, and you still hit the error, chances are you might need 
to swap out your MB and CPU/RAM to something newer (not to mention the 
PS).  I'd recommend ECC based systems if at all possible.  Xfs can and 
will get very unhappy if bits are flipped on its data structures while 
you are making changes to the file system.

--

Joe

>
> Cheers,
> -- jra
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
