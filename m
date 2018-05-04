Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751765AbeEDVjs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 17:39:48 -0400
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
References: <20180313205911.26082-1-mcgrof@kernel.org>
 <44fa85af-7d59-9909-20e4-c8351f630fb4@sandeen.net>
 <54b16a43-353a-6cde-34ce-04d678131b0c@sandeen.net>
 <20180504213646.GO26569@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e2a219c-975f-b99a-c27e-d141d7028be9@sandeen.net>
Date: Fri, 4 May 2018 16:39:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180504213646.GO26569@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On 5/4/18 4:36 PM, Darrick J. Wong wrote:
> On Fri, May 04, 2018 at 04:31:56PM -0500, Eric Sandeen wrote:
>> On 3/13/18 10:21 PM, Eric Sandeen wrote:
>>>> There is only a subset of options allowed to be set on the configuration
>>>> file, 
>>
>>> I think this is problematic - allowing only booleans is pretty
>>> arbitrary.
>>
>> ...
>>  
>>>> and currently only 1 or 0 are acceptable values. The default
>>>> parameters you can override on a configuration file and their current
>>>> built-in default settings are:
>>>>
>>>> [data]
>>>> noalign=0
>>
>> ...
>>
>>>> We have floated around enough bike shedding emails to have at least reached
>>>> a consensus on the fact that we'd be only supporting a mimimum set of default
>>>> parameters and would strive to simplify our parser as much as possible.
>>
>>> See above - sorry for not chiming in sooner, but I don't think an arbitrary
>>> restriction to the boolean options will be sufficient in the long run.
>>
>> Ok, I'm rethinking this concern now.
>>
>> It seems like we may have two separate but related purposes for a mkfs config file:
>>
>> 1) Set system-wide defaults based on kernel and/or OS support.
>> 2) Set specific-use defaults, such as "mkfs.xfs -c gluster" etc.
>>
>> For the former, it may well only be the booleans that matter.  For the latter,
>> it may be more, like setting inode size, or directory block size, etc.
>>
>> Is there anything we'd reasonably want to set system-wide that's /not/ a
>> boolean?  If not, the maybe that can be Phase 1 as long as the config file
>> format doesn't need to change; we can just add to the list of supported config
>> options at a later date, perhaps?
> 
> Looking at the *documented* mkfs options, I think it'd be useful for
> cloud users to be able to set cowextsize and extsize from mkfs.

Fair, but I guess my point is that that falls more into special-use
config optimization, vs. supported/not-supported defaults.

And as such could maybe come in Phase 2 of the grand plan.  ;)

-Eric

> As I was saying on irc, I /think/ the options (Allison feel free to
> chime in here) that we want are....
> 
> -m crc,finobt,rmapbt,reflink,projinherit,extszinherit,cowextsize,extsize
> -i maxpct,sparse
> -n ftype
> 
> --D


