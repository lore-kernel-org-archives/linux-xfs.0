Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 20:56:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E3uBAR012598
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:56:15 -0700
Message-ID: <4802D5FE.80005@sgi.com>
Date: Mon, 14 Apr 2008 13:56:46 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW XFSQA test out xfs_attr_shortform_bytesfit attr2/attr1
 fix
References: <47FC79FC.5020803@sgi.com> <20080410053601.GK108924158@sgi.com> <4802B4E8.3070807@sgi.com> <20080414032229.GV103491721@sgi.com>
In-Reply-To: <20080414032229.GV103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "bnaujok@sgi.com via BugWorks" <bnaujok@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asgqa@sgi.com>

Hi Dave,

David Chinner wrote:
> On Mon, Apr 14, 2008 at 11:35:36AM +1000, Timothy Shimmin wrote:
>> Hi Dave and Barry,
>>
>> David Chinner wrote:
>>> On Wed, Apr 09, 2008 at 06:10:36PM +1000, Timothy Shimmin wrote:
>>>> Hi there,
>>>>
>>>> A test to test out Eric's fix for xfs_attr_shortform_bytesfit
>>>> bug when going from attr2 to attr1.
>>>>
>>>> With TOT kernel, without patch, one can see the corrupted inline
>>>> dirents. With patch, all is well.
>>>>
>>>> The 186.out _should_ be output'ing ATTR2 for the db version
>>>> command but I'm awaiting Barry's xfsprogs checkin to fix that one -
>>>> and then I will regenerate it.
>>> Really? I'm seeing it fail with ATTR2 in the xfs_db output...
>>>
>> That's what I used to see until I updated to TOT kernel.
>> That's weird.
> 
> It's likely due to Eric's change to make sb_badfeatures2 =
> sb_features2. That will make userspace pick up the attr2 feature
> properly regardless of where it is. Perhaps xfs_db is b0rked
> w.r.t. reporting attr vs attr2....
> 
> Cheers,
> 
> Dave.

I'm not sure, but with Barry's latest checkins, all seems well
and I'm now getting the attr2 output as expected.

Which just leaves the ATTR and ATTR2 output when I add an EA
to a file on an ATTR2 file-system.
It is naturally the kernel that is doing this.
The existing behaviour prior to ATTR2, was to
turn on ATTR as soon as one added an EA to a file (added by doucette).

> xfs_bmap_add_attrfork
....
>         if (!xfs_sb_version_hasattr(&mp->m_sb) ||
>            (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
>                 __int64_t sbfields = 0;
> 
>                 spin_lock(&mp->m_sb_lock);
>                 if (!xfs_sb_version_hasattr(&mp->m_sb)) {
>                         xfs_sb_version_addattr(&mp->m_sb);
>                         sbfields |= XFS_SB_VERSIONNUM;
>                 }
>                 if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
>                         xfs_sb_version_addattr2(&mp->m_sb);
>                         sbfields |= (XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
>                 }

So I would say it is intentional and we are preserving the behaviour of
knowing if we have EAs in use or not.
I guess it seems a bit redundant but it may well cause less problems in
doing so and doesn't hurt.

--Tim
