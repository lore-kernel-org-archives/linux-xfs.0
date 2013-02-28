Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF6297F93
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 15:39:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98B4C304043
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 13:38:57 -0800 (PST)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	Dn9LjZm7LY9KgZkq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Feb 2013 13:38:52 -0800 (PST)
Received: by mail-wi0-f178.google.com with SMTP id hq4so2718688wib.17
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 13:38:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512EEAB8.4070306@sandeen.net>
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D3856.5050305@sandeen.net>
	<CA+AKrqC+6nXuCxdY08MBLsjv1fOPJ6=1ruTHsfGqxosQmCi_jQ@mail.gmail.com>
	<512D49E2.40003@sandeen.net>
	<CA+AKrqCrphO-eKy0n=70O9hmB3mXttOsKmTdfRnPxgJM3_PAkQ@mail.gmail.com>
	<512E3BB2.6060407@sandeen.net>
	<CA+AKrqDq5xCNQo1X=MeRBq54ka0FGJEV5Rn6OzwY7eBfJ+8Wkw@mail.gmail.com>
	<512E7639.20205@sandeen.net> <512E89C2.9000302@sandeen.net>
	<CA+AKrqDaY4cgP+EPLepzUOU2jAOygTuj-0xDtOaGf+O0aRZV_g@mail.gmail.com>
	<512E903A.2020405@sandeen.net>
	<CA+AKrqAv7-5gGj_cNBNj=-nChKPzi+_HZmH=z2UABG9pDOmpBg@mail.gmail.com>
	<512EDF37.4050802@sandeen.net> <512EE20A.7010103@sandeen.net>
	<512EEAB8.4070306@sandeen.net>
Date: Thu, 28 Feb 2013 15:38:51 -0600
Message-ID: <CA+AKrqCuyb0mD7tQgjGDbSP5Gc+OohtU76htEazO=guxJUgddQ@mail.gmail.com>
Subject: Re: Read corruption on ARM
From: Jason Detring <detringj@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/27/13, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/27/13 10:50 PM, Eric Sandeen wrote:
>> On 2/27/13 10:38 PM, Eric Sandeen wrote:
>>
>> ...
>>
>>> re-cc'ing xfs list
>>>
>>> So I used pahole to look at all structs, objdump -d to disassemble,
>>> and md5sum'd the results to see what's different.
>>>
>>> pi@raspberrypi ~ $ md5sum cross/*.dis cross/*.pahole native/*.dis
>>> native/*.pahole
>>>
>>> <manual sort>
>>>
>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O1-g.ko.pahole
>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O2-g.ko.pahole
>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-Os-g.ko.pahole
>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O1-g.ko.pahole
>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O2-g.ko.pahole
>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-Os-g.ko.pahole
>>>
>>> so all structures look identical, good - but:
>>>
>>> while disassembly of these two modules match:
>>>
>>> d76f6ebf4d8a1b9f786facefbcf16f69  cross/xfs-O1-g.ko.dis
>>> d76f6ebf4d8a1b9f786facefbcf16f69  native/xfs-O1-g.ko.dis
>>>
>>> do you see the problem w/ the cross-compiled xfs-O1-g.ko as well?

No, I didn't.  The problem has only shown itself on the -O2 builds,
both native and cross-compiled.  Lower optimization levels don't show
any of the symptoms.

Perhaps a better comparison would be-O2 builds among working and
non-working compilers?   You'd asked for these before, but I just
finished them today.  The modules, build logs, and fs/xfs/ build trees
are up at
  <http://www.splack.org/~jason/projects/xfs-arm-corruption/3.6.11-g89caf39/>
A quick rundown:
  -cross-gcc4.4:  OK
  -cross-gcc4.5:  OK
  -cross-gcc4.6:  BAD
  -cross-gcc4.7:  BAD
  -cross-gcc4.8:  OK
Some of these don't seem to want to rmmod after they've been inserted.
 Argh reboots.


>>> the others differ:
>>>
>>> 349f3490a49f2ce539c2b058914f64f0  native/xfs-Os-g.ko.dis
>>> 91c8e8230774808b538c21a83106a5d7  cross/xfs-Os-g.ko.dis
>>>
>>> 649338e1b8eeed6a294504fc76a39cb0  native/xfs-O2-g.ko.dis
>>> e52c2a48277326c313bba76aa0b33ab7  cross/xfs-O2-g.ko.dis
>>>
>>> The diff of the disassembly of the others is huge, hard to
>>> know where to start just yet.  Need an objdump mode that only
>>> shows function-relative addresses or something to cut down
>>> on the noise.
>>
>> Could you try the same, to isolate the differences: objdump -d
>> all of the *.o files for, say, the -O2 build, md5sum & compare,
>> and see which ones differ?

Er, uh...  oops! :-)    I'd scrubbed the objects between each test, so
each module had to be regenerated.  So, the intermediate objects won't
match the various xfs-O2-g.ko's you've already downloaded.  Look in
the -cross-gcc4.7 and -native-gcc4.7 subdirectories for new copies.


# pwd
/xfsdebug/tracetest/3.6.11-g89caf39/xfs-modules-native-gcc4.7/xfs-O2-g-obj
# for obj in *.o; do
if [ "$(objdump -d $obj | md5sum)" != "$(cd
../../xfs-modules-cross-gcc4.7/xfs-O2-g-obj/ && objdump -d $obj |
md5sum)" ]; then
echo "obj $obj is different";  fi; done
obj xfs.o is different
obj xfs_attr_leaf.o is different
obj xfs_bmap.o is different
obj xfs_dir2_block.o is different
obj xfs_itable.o is different
obj xfs_log.o is different
obj xfs_log_recover.o is different



> And one more test.  Every time you hit the error, it causes
> a log replay on the next mount since the fs has shut down.
>
> Can you try
>
> # mount; umount; mount; test
>
> so that you start the test from a clean mount, and see if you still hit it?
>
> Maybe save that image off before you do that test just in case it changes
> the state.

I'm not sure on that.  Even in read-write mode, the notice in my
kernel log has always been "Corruption detected.  Unmount and run
xfs_repair".  It's never been a forced filesystem shutdown, just a
stern warning and half-accessible files.  The next mount always seems
to be clean.

[89574.079876] XFS (loop0): Corruption detected. Unmount and run xfs_repair
[89587.269316] XFS (loop0): Mounting Filesystem
[89587.444629] XFS (loop0): Ending clean mount

I usually mount read-only and it doesn't seem like the image's md5sum
doesn't change between runs.  I made a copy then mounted it read-write
a time or two.  The md5sum changed between mounts.  However, I am
still seeing the error when attempting to read the directory.  The
mounted-rw-checked image is up at
  <http://www.splack.org/~jason/projects/xfs-arm-corruption/journalreplaytest/>


Jason

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
