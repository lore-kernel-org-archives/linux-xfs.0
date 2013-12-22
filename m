Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C34D47F52
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 15:01:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B27CAC003
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 13:01:20 -0800 (PST)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	SEjx6x96ZZeBgcd8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Dec 2013 13:01:19 -0800 (PST)
Received: by mail-qc0-f171.google.com with SMTP id c9so4208455qcz.2
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 13:01:19 -0800 (PST)
Received: from [192.168.0.129] (rrcs-97-79-21-178.se.biz.rr.com.
	[97.79.21.178])
	by mx.google.com with ESMTPSA id e2sm18072496qas.21.2013.12.22.13.01.18
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sun, 22 Dec 2013 13:01:18 -0800 (PST)
Message-ID: <52B7531A.6070909@gmail.com>
Date: Sun, 22 Dec 2013 16:01:14 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de>	<52B118A9.8080905@hardwarefreak.com>	<52B178AA.6040302@pzystorm.de>	<52B2FE9E.50307@hardwarefreak.com>	<52B41B67.9030308@pzystorm.de>	<52B439D1.3020205@hardwarefreak.com>	<20131221053032.GA3220@dastard>
	<52B6AE4D.5020104@hardwarefreak.com>
In-Reply-To: <52B6AE4D.5020104@hardwarefreak.com>
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

On 12/22/2013 04:18 AM, Stan Hoeppner wrote:

> For the record, again, I've never used dm-crypt.  I'm just trying to
> work through the layers to identify the source of Kevin's problems.  So
> please don't clobber me too hard for going OT, or trying to speak
> (somewhat) intelligently about something I'm just learning about...

This stuff isn't easy.  There are a lot of security-vs-speed tradeoffs, 
and kernel support varies by processor and architecture.  Take this 
example from x86:

# info from fdisk:
/dev/sda5         8404992    10502143     1048576   83  Linux

# cryptsetup status /dev/mapper/wCrypt
/dev/mapper/wCrypt is active.
  type:    LUKS1
  cipher:  aes-xts-essiv:sha256
  keysize: 512 bits
  device:  /dev/sda5
  offset:  4096 sectors
  size:    2093056 sectors
  mode:    read/write

What this jibberish means from a speed standpoint is this:

aes: had assembly speedups in the kernel; NIST approved;

xts: almost as fast as cbc while being more secure;

essiv: "plain" is faster, but essiv is more secure;

sha256: it seemed like an ok hash;

512 bits: much slower than 256 or 128 bits, but hopefully more secure, fine 
for a small partition like this.

A similar "cryptsetup status <cryptname>" from Kevin might help you 
benchmark things, and Kevin might explain his rationale without blowing his 
cover ;-)  A `zcat /proc/config.gz` | grep CRYPTO` might help you see what 
kernel support he has as well.

Dave's recent post about I/O latency with dm-crypt reads/writes might be 
the answer that you're seeking.  I just wanted to put in my two cents.

Good luck!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
