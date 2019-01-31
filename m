Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42896 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbfAaPt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 10:49:26 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached
 pages"
Date: Thu, 31 Jan 2019 15:48:11 +0000
Message-ID: <E8895615-9DDA-4FC5-A3AB-1BE593138A89@fb.com>
References: <20190130041707.27750-1-david@fromorbit.com>
 <20190130041707.27750-2-david@fromorbit.com>
 <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com> <20190131013403.GI4205@dastard>
In-Reply-To: <20190131013403.GI4205@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Roman Gushchin <guro@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mhocko@kernel.org" <mhocko@kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>

On 30 Jan 2019, at 20:34, Dave Chinner wrote:

> On Wed, Jan 30, 2019 at 12:21:07PM +0000, Chris Mason wrote:
>>
>>
>> On 29 Jan 2019, at 23:17, Dave Chinner wrote:
>>
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> This reverts commit a76cf1a474d7dbcd9336b5f5afb0162baa142cf0.
>>>
>>> This change causes serious changes to page cache and inode cache
>>> behaviour and balance, resulting in major performance regressions
>>> when combining worklaods such as large file copies and kernel
>>> compiles.
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D202441
>>
>> I'm a little confused by the latest comment in the bz:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D202441#c24
>
> Which says the first patch that changed the shrinker behaviour is
> the underlying cause of the regression.
>
>> Are these reverts sufficient?
>
> I think so.

Based on the latest comment:

"If I had been less strict in my testing I probably would have=20
discovered that the problem was present earlier than 4.19.3. Mr Gushins=20
commit made it more visible.
I'm going back to work after two days off, so I might not be able to=20
respond inside your working hours, but I'll keep checking in on this as=20
I get a chance."

I don't think the reverts are sufficient.

>
>> Roman beat me to suggesting Rik's followup.  We hit a different=20
>> problem
>> in prod with small slabs, and have a lot of instrumentation on Rik's
>> code helping.
>
> I think that's just another nasty, expedient hack that doesn't solve
> the underlying problem. Solving the underlying problem does not
> require changing core reclaim algorithms and upsetting a page
> reclaim/shrinker balance that has been stable and worked well for
> just about everyone for years.
>

Things are definitely breaking down in non-specialized workloads, and=20
have been for a long time.

-chris
