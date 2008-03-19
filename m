Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 08:35:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JFZ0nc017952
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 08:35:02 -0700
Received: from ventoso.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B405D6BE016
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 08:35:32 -0700 (PDT)
Received: from ventoso.org (61.pool85-52-226.static.orange.es [85.52.226.61]) by cuda.sgi.com with ESMTP id l0sYTfH1MgU2nwpM for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 08:35:32 -0700 (PDT)
Message-ID: <47E132A0.8030000@ventoso.org>
Date: Wed, 19 Mar 2008 16:34:56 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com> <20080319002307.GA11349@josefsipek.net> <47E0F746.1090508@ventoso.org> <47E10CBA.9020904@sandeen.net> <47E11F4A.3090205@ventoso.org> <47E12D20.4010901@sandeen.net>
In-Reply-To: <47E12D20.4010901@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

En/na Eric Sandeen ha escrit:

[posting also to the list since I think it may be interesting for 
everybody, with sensitive information removed]

> Luca Olivetti wrote:
>> En/na Eric Sandeen ha escrit:
>>
>>> do you still have that small fs image?
>> Here's the link
>> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>>
>> Please tell me when you have downloaded it, as I'm not sure the image is 
>> completely safe, so I don't like having it online.
>>
>> Bye
> 
> So, made an xfs_metadump image of that (just smaller, easier to move
> around):
> 
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> 
> (don't worry, it's not linked from anywhere, I can take it down when you
> grab it) and then:
> 
> bunzip2 sda2-meta.img.bz2
> xfs_mdrestore sda2-meta.img sda2.img
> mkdir mnt
> mount -o loop sda2.img  mnt/
> ls mnt
> ls mnt/sbin
> 
> and this all worked fine for me on 2.6.25, eabi.

good to know!

> 
> Linux fedora-arm 2.6.25-rc2 #2 Sat Feb 23 13:58:22 CST 2008 armv5tejl
> armv5tejl armv5tejl GNU/Linux
> 
> Can you try the same steps on your box?

I'll report your result on the nas-central.org forum and I'll check 
what's the status of 2.6.25-rc2 on the linkstation (though I see that 
the orion.git repository is only updated to rc1).
If I find that it's possible to boot this kernel with no (or little ;-) 
risk I'll try it.

Bye
-- 
Luca
