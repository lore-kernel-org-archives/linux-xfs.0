Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D6B07F50
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 20:50:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D10B304048
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 18:50:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xBavuboEMYa4fFAc for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 18:50:14 -0800 (PST)
Message-ID: <513BF4E5.8080006@sandeen.net>
Date: Sat, 09 Mar 2013 20:50:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<51380FD3.5010302@hardwarefreak.com>
	<CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
In-Reply-To: <CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
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
To: Julien FERRERO <jferrero06@gmail.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On 3/7/13 7:04 AM, Julien FERRERO wrote:
>> It may be unrelated to your corruption, problem but I'm curious why you
>> are specifying a 32MB log section instead of letting mkfs.xfs make the
>> log size decision.
> 
> I honestly don' know, the rebuild script was written 8 years ago by an
> engineer that since left the company.
> 
> Is 32MB a short log space for a 1.5 TB of data ?

$ mkfs.xfs -dfile,name=fsfile,size=1536g
meta-data=fsfile                 isize=256    agcount=4, agsize=100663296 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=402653184, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=196608, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Default would be 768M w/ current xfsprogs.

So I'd say yes it's short.  You might do well to re-examine any old, crufty
"engineer left a while ago" tunings.  Defaults are defaults for a reason,
if you don't know why you're tuning something it may well be the wrong
choice.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
