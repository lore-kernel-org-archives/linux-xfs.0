Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40330 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388241AbeGXHhj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 03:37:39 -0400
Subject: Re: xfsprogs-dev failing to build
References: <20180724040944.GH27624@mayhem.atnf.CSIRO.AU>
 <20180724042738.GS4813@magnolia>
 <20180724043734.GI27624@mayhem.atnf.CSIRO.AU>
 <20180724062200.GT4813@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dff339d2-9241-87b1-16f6-88608461129d@sandeen.net>
Date: Mon, 23 Jul 2018 23:32:43 -0700
MIME-Version: 1.0
In-Reply-To: <20180724062200.GT4813@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Vincent McIntyre <vincent.mcintyre@csiro.au>
Cc: linux-xfs@vger.kernel.org



On 7/23/18 11:22 PM, Darrick J. Wong wrote:
> On Tue, Jul 24, 2018 at 02:37:34PM +1000, Vincent McIntyre wrote:
>> On Mon, Jul 23, 2018 at 09:27:38PM -0700, Darrick J. Wong wrote:
>>> On Tue, Jul 24, 2018 at 02:09:44PM +1000, Vincent McIntyre wrote:
>>>> Hi
>>>>
>>>> I am trying to build the latest xfsprogs on an older system,
>>>> details below. The configure script is failing on what appears
>>>> to be an unexpanded m4 macro,
>>>>
>>>>   PKG_CHECK_MODULES(libicu, icu-i18n, have_libicu=yes, have_libicu=no)
>>>
>>> Hmmm, I thought that pkg.m4 would be pulled in via aclocal
>>> automatically, but I could be wrong. :/
>>>
>>> What version of pkg-config (or I guess pkgconf?) is on the system?
>>>
>>
>> It was not actually installed, and that was the problem.
>> The tree builds ok now, and xfs_repair -n works ok.
>>
>> A bit odd pkg-config was not installed, I had installed the
>> 'build-essential' metapackage but I guess it didn't pull in.
>>
>>>> I'm not quite sure how to work around this or if it is a bug.
>>>> Any advice would be appreciated.
>>>
>>> Definitely some sort of bug...
>>
>> I think the only fix needed is for the xfs.org faq page
>>
>> - apt-get install libtool automake gettext libblkid-dev uuid-dev
>> + apt-get install libtool automake gettext libblkid-dev uuid-dev pkg-config
>>
>> Possibly libicu-dev should be added to the list also.
> 
> FWIW they're both listed in debian/control as build dependencies...
> 
> Does anyone out there have the connections to the xfs.org maintainers to
> fix that...?

I ... guess I still have a wiki login.  I added it.

Another reason why wikis actually suck, and we should keep all documentation
under SCM control.  :/

-Eric
