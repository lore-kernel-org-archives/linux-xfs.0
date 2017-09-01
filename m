Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752338AbdIAUhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 16:37:00 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Date: Fri, 1 Sep 2017 20:36:53 +0000
Message-ID: <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
 <20170901193237.GF29225@bfoster.bfoster>
In-Reply-To: <20170901193237.GF29225@bfoster.bfoster>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D2C9A95DE245BF4397941B865E52A41B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>



> On Sep 1, 2017, at 12:32 PM, Brian Foster <bfoster@redhat.com> wrote:
>=20
> On Fri, Sep 01, 2017 at 06:39:09PM +0000, Richard Wareing wrote:
>> Thanks for the quick feedback Dave!  My comments are in-line below.
>>=20
>>=20
>>> On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>=20
>>> Hi Richard,
>>>=20
>>> On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
> ...
>>>> add
>>>> support for the more sophisticated AG based block allocator to RT
>>>> (bitmapped version works well for us, but multi-threaded use-cases
>>>> might not do as well).
>>>=20
>>> That's a great big can of worms - not sure we want to open it. The
>>> simplicity of the rt allocator is one of it's major benefits to
>>> workloads that require deterministic allocation behaviour...
>>=20
>> Agreed, I took a quick look at what it might take and came to a similar =
conclusion, but I can dream :).
>>=20
>=20
> Just a side point based on the discussion so far... I kind of get the
> impression that the primary reason for using realtime support here is
> for the simple fact that it's a separate physical device. That provides
> a basic mechanism to split files across fast and slow physical storage
> based on some up-front heuristic. The fact that the realtime feature
> uses a separate allocation algorithm is actually irrelevant (and
> possibly a problem in the future).
>=20
> Is that an accurate assessment? If so, it makes me wonder whether it's
> worth thinking about if there are ways to get the same behavior using
> traditional functionality. This ignores Dave's question about how much
> of the performance actually comes from simply separating out the log,
> but for example suppose we had a JBOD block device made up of a
> combination of spinning and solid state disks via device-mapper with the
> requirement that a boundary from fast -> slow and vice versa was always
> at something like a 100GB alignment. Then if you formatted that device
> with XFS using 100GB AGs (or whatever to make them line up), and could
> somehow tag each AG as "fast" or "slow" based on the known underlying
> device mapping, could you potentially get the same results by using the
> same heuristics to direct files to particular sets of AGs rather than
> between two physical devices? Obviously there are some differences like
> metadata being spread across the fast/slow devices (though I think we
> had such a thing as metadata only AGs), etc. I'm just handwaving here to
> try and better understand the goal.
>=20


Sorry I forgot to clarify the origins of the performance wins here.   This =
is obviously very workload dependent (e.g. write/flush/inode updatey worklo=
ads benefit the most) but for our use case about ~65% of the IOP savings (~=
1/3 journal + slightly less than 1/3 sync of metadata from journal, slightl=
y less as some journal entries get canceled), the remainder 1/3 of the win =
comes from reading small files from the SSD vs. HDDs (about 25-30% of our f=
ile population is <=3D256k; depending on the cluster).  To be clear, we don=
't split files, we store all data blocks of the files either entirely on th=
e SSD (e.g. small files <=3D256k) and the rest on the real-time HDD device.=
  The basic principal here being that, larger files MIGHT have small IOPs t=
o them (in our use-case this happens to be rare, but not impossible), but s=
mall files always do, and when 25-30% of your population is small...that's =
a big chunk of your IOPs.

The AG based could work, though it's going to be a very hard sell to use dm=
 mapper, this isn't code we have ever used in our storage stack.  At our sc=
ale, there are important operational reasons we need to keep the storage st=
ack simple (less bugs to hit), so keeping the solution contained within XFS=
 is a necessary requirement for us.

Richard


> Brian
>=20
>>>=20
>>> Cheers,
>>>=20
>>> Dave.
>>> --=20
>>> Dave Chinner
>>> david@fromorbit.com
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

