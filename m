Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 08:37:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74FafDW010589
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 08:36:41 -0700
Message-ID: <44D36985.1090006@thebarn.com>
Date: Fri, 04 Aug 2006 10:36:37 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM>
In-Reply-To: <20060804141012.GA26@kickball-mn.Central.Sun.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dean Roehrich <dean.roehrich@sun.com>
Cc: Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

Dean Roehrich wrote:
> On Fri, Aug 04, 2006 at 02:18:13PM +1000, Vlad Apostolov wrote:
>   
>> Hi Russel,
>>
>> I don't understand in details the build changes but they seam to be fine.
>>     
>
> Vlad, why do they seem fine?
>
>   
>> In summary if the build system can find the DMAPI lib installed it will
>> use hsmapi_noop.c otherwise hsmapi.c.
>> The return code of HsmInitFileContext() stub probably should be non zero.
>>
>> It is looking good.
>>     
>
> So this is determined at build time...so when you're using a version of
> xfsdump/xfsrestore how do you know you're _not_ using one that is DMAPI-aware
> _before_ you get into trouble with an invalid dump?
>   
I appears as if the Hsm routines are only used if the -a flag is given 
to xfsdump.
(dump DMF dualstate files as offline)
 
 From what I can tell the only users that will need the HSM routines 
would be Suse
based installs or somebody doing a custom kernel with the xfs-tree from oss.
Anybody running with a kernel.org kernel would have no need for  dmapi 
support in xfs dump/restore.
(This includes the Fedora kernel with currently does does build the 
xfsdump package)
Under the current scheme in order to get xfsdump at all you need to 
build and install the dmapi and dmapi-devel
packages, which seemed kinda silly to me on system that don't have the 
kernel support for dmapi.
So basically I just stubbed out the Hsm functions is the case of no 
dmapi libraries

The dlopen is a good idea but still requires that build machine has the 
dmapi libraries installed
which seems like extra work if they are never going to be used.

> Assuming that issue is addressed, here's another:  The libdm is a shared
> object, so why not take advantage of that and load it with dlopen?  Then the
> issue is determined at runtime rather than build time.  This is easy, and even
> DMF does it this way.
>
> Dean
>
>   
