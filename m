Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Dec 2006 07:45:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBNFjYqw012214
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 07:45:35 -0800
Message-ID: <458D4EEB.3060501@sandeen.net>
Date: Sat, 23 Dec 2006 09:44:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Possible performance problem introduced between kernel 2.6.15
 and 2.6.17 on xfs code
References: <458D4845.2010803@emaze.net>
In-Reply-To: <458D4845.2010803@emaze.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: fdegrassi <francesco.degrassi@emaze.net>
Cc: linux-xfs@oss.sgi.com

fdegrassi wrote:
> Hi all,
> i noticed that changing from kernel 2.6.15 to 2.6.17, gnomevfs-copy 
> operations suffered an heavy performance hit (20 times slower).
> I checked quickly (i am not a kernel hacker) and i think it could be 
> related to libgnomevfs calling fadvice POSIX_FADV_DONTNEED  (in 
> gnome_vfs_forget_cache, disabling this behaviour gets back normal 
> performance).
> I am not able to dig deeper than this, anyway it could be a starting point.
> The relevant gnome bugzilla reference is the following: 
> http://bugzilla.gnome.org/show_bug.cgi?id=363400
> 
> Francesco Degrassi
> 
> 

Is a copy command from the shell affected, or just gnome point-n-click?

-Eric
