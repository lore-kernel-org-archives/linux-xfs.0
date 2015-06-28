Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D53E7F51
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 17:29:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07E6B304043
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 15:29:53 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	HJo000pnJ50u0OM7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 28 Jun 2015 15:29:51 -0700 (PDT)
Received: by wicgi11 with SMTP id gi11so57103831wic.0
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 15:29:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55907148.1050509@sandeen.net>
References: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
	<55907148.1050509@sandeen.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 29 Jun 2015 01:29:10 +0300
Message-ID: <CAGqmi75V-DWbJR0LPOqwhg3s501G_kSDpcPjbPi6nuGWOJNrKA@mail.gmail.com>
Subject: Re: Q: xfs_db: invalid numrecs (*) in bmapbtd block
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

2015-06-29 1:12 GMT+03:00 Eric Sandeen <sandeen@sandeen.net>:
> On 6/28/15 1:44 PM, Timofey Titovets wrote:
>> Good time of day list,
>> i do regular check fragmentation on my servers and xfs_db show strange erros:
>
> No need, really.
>
> http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

I just collects metrics for Zabbix monitoring.

>> # xfs_db -c frag -r /dev/sdc1
>> invalid numrecs (51914) in bmapbtd block
>> invalid numrecs (2827) in bmapbtd block
>
> ...
>
>> actual 504454, ideal 126776, fragmentation factor 74.87%
>
>
>
>> I already google error, and can't find any answer or explanation what
>> is it, how danger it or something like.
>> It's a production servers with several TB of data and this output make
>> me unhappy. =.=
>
> does xfs_repair find any errors?

i can't run xfs_repair on mounted fs as you know =)

>> And i can't do fast stop it, unmount and check file system.
>> (this is nfs server for virtual machines images)
>
> Oh.  So you're doing it with an online/mounted filesystem?

Yes, it must be not a problem.
(This error happen only on 2 from 9 servers, after many month of
stable working, others seems in good state)

> The on-disk filesystem isn't necessarily consistent when mounted,
> some of that consistency lives in the log.
>
>
> You're likely just seeing that inconsitency because you're reading
> it while it's mounted; possibly even while it's being modified.
>
> -Eric

I already thinked about this case, and it seems incredible.
1. i can get consistent or very close to consistent fs, by run 'sync'
2. Okay, supposing you are right,
then i must get different errors over time, because fs will change own
state over time (also after every sync call).
But its don't happen, i get same errors over long period of time (1
day+, i think on busy FS server, its enoug to think what data on disk
has changed)
Also, i have several others server, and on it i didn't see this
problem (over 2-3 month).


Then I can conclude this is errors in FS, only what matter to me now,
this type of errors can damage my data and i must move virtual
machines from it ASAP, or i can continue working and this is just
"artefact".

Fix me if i'm wrong.

>> Thanks for any help, anyway.
>>
>

-- 
Have a nice day,
Timofey.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
