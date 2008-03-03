Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 20:18:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m234Hmux003913
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 20:17:50 -0800
Message-ID: <47CB7D52.2030704@sgi.com>
Date: Mon, 03 Mar 2008 15:23:46 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: filesystem corruption in linus tree
References: <03F8FD43-322F-41E3-A7A0-CD4E9AD8B4DE@ap.physik.uni-giessen.de> <200802252347.50576.marc.dietrich@ap.physik.uni-giessen.de> <47C3C20A.90603@sgi.com> <200802262100.18631.marc.dietrich@ap.physik.uni-giessen.de>
In-Reply-To: <200802262100.18631.marc.dietrich@ap.physik.uni-giessen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

Marc Dietrich wrote:
> Hi again,
> 
> On Tuesday 26 February 2008 08:38:50 Lachlan McIlroy wrote:
>> Marc Dietrich wrote:
>>> Hi,
>>>
>>> On Monday 25 February 2008 01:36:28 Barry Naujok wrote:
>>>> On Sun, 24 Feb 2008 20:58:26 +1100, Marc Dietrich
>>>>
>>>> <Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
>>>>> Hi,
>>>>>
>>>>> somewhere after the release of 2.6.24 my xfs filesystem got corrupted.
>>>>> Initialy I thought it was only related to the readdir bug.
>>>>> (http://oss.sgi.com/archives/xfs/2008-02/msg00027.html) So I waited for
>>>>> the fix to go into mainline. Yesterday I tried again, but got this
>>>>> error during boot:
> 
> <sniped>
> 
>> We've had a few problems reported with XFS on 32-bit powermacs and the
>> culprit appears to be some changes to bit manipulation routines.  Could you
>> please try reverse applying the attached patches and see if the problem is
>> resolved?
> 
> I saw, that you already pushed it into mainline - for a good reason ;-) Works 
> as expeted.
> 
> Please also don't forget 2.6.24-stable !

The changes that caused this regression went into 2.6.25-rc1 so no need for a
2.6.24 stable fix.
