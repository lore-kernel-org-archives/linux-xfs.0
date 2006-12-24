Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Dec 2006 16:37:32 -0800 (PST)
Received: from deflector.emaze.net (deflector.emaze.net [213.178.220.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBO0bOqw011126
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 16:37:27 -0800
Received: from localhost (localhost [127.0.0.1])
	by deflector.emaze.net (Postfix) with ESMTP id B1957F2816D
	for <linux-xfs@oss.sgi.com>; Sun, 24 Dec 2006 01:35:17 +0100 (CET)
Received: from deflector.emaze.net ([127.0.0.1])
	by localhost (deflector [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09604-09 for <linux-xfs@oss.sgi.com>;
	Sun, 24 Dec 2006 01:35:17 +0100 (CET)
Received: from [192.168.10.55] (host68-236-dynamic.5-87-r.retail.telecomitalia.it [87.5.236.68])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by deflector.emaze.net (Postfix) with ESMTP id 3DDF6F28080
	for <linux-xfs@oss.sgi.com>; Sun, 24 Dec 2006 01:35:17 +0100 (CET)
Message-ID: <458DCB8D.3040804@emaze.net>
Date: Sun, 24 Dec 2006 01:36:29 +0100
From: fdegrassi <francesco.degrassi@emaze.net>
MIME-Version: 1.0
Subject: Re: Possible performance problem introduced between kernel 2.6.15
 and 2.6.17 on xfs code
References: <458D4845.2010803@emaze.net> <458D4EEB.3060501@sandeen.net>
In-Reply-To: <458D4EEB.3060501@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

The specific problem is related to gnome point-n-click only.
Anyway, I could be wrong, but i don't think it is a bug in gnome because:
1. it affects specifically local XFS filesystems only
2. the problem is not present on kernel 2.6.15 (I tested 2.6.17 and 
2.6.15, both on ubuntu 6.10)
3. the problem does not manifest if i disable the call to 
gnome_vfs_forget_cache, that, for what i understand, simply calls 
fadvice POSIX_FADV_DONTNEED.

More info can be found on gnome bugzilla entry.
Francesco Degrassi


Eric Sandeen wrote:
> fdegrassi wrote:
>> Hi all,
>> i noticed that changing from kernel 2.6.15 to 2.6.17, gnomevfs-copy 
>> operations suffered an heavy performance hit (20 times slower).
>> I checked quickly (i am not a kernel hacker) and i think it could be 
>> related to libgnomevfs calling fadvice POSIX_FADV_DONTNEED  (in 
>> gnome_vfs_forget_cache, disabling this behaviour gets back normal 
>> performance).
>> I am not able to dig deeper than this, anyway it could be a starting 
>> point.
>> The relevant gnome bugzilla reference is the following: 
>> http://bugzilla.gnome.org/show_bug.cgi?id=363400
>>
>> Francesco Degrassi
>>
>>
>
> Is a copy command from the shell affected, or just gnome point-n-click?
>
> -Eric
