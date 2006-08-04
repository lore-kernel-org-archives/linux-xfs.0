Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 10:34:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74HXpDW010186
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 10:33:51 -0700
Message-ID: <44D384E2.5080702@sandeen.net>
Date: Fri, 04 Aug 2006 12:33:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com>
In-Reply-To: <44D379A6.9040200@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: Dean Roehrich <dean.roehrich@sun.com>, Russell Cattelan <cattelan@thebarn.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

Bill Kendall wrote:
> Dean Roehrich wrote:
>> On Fri, Aug 04, 2006 at 10:36:37AM -0500, Russell Cattelan wrote:
>>
>>
>>> I appears as if the Hsm routines are only used if the -a flag is 
>>> given to xfsdump.
>>> (dump DMF dualstate files as offline)
>>
>>
>> If use of -a causes xfsdump to fail then that may be sufficient.
> 
> Then what? Each user (admittedly, this is a small number) has to rebuild
> xfsdump locally, and then do so every time their package manager grabs
> an updated xfsdump? 

Well... if you're using SLES or ProPack or whatever, -a will work fine, when you 
get updates from your dmapi-supporting distro it will continue to work fine...

But if you're using fedora or whatnot, -a will return a (hopefully helpful) 
error message and quit, and if you -really- want to use dmapi, you'll have to 
build a custom kernel and dmapi userspace anyway.  Rebuilding xfsprogs to go 
with it doesn't seem like too big a deal...  In such a scenario you'd tell your 
package manager to exclude both kernel & xfsprogs.

Anyway, other proposals also seem reasonable, so I won't push this point too much :)

-Eric
