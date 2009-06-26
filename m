Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QLKSS9226182 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 16:20:29 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9F649B20B2
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 14:29:34 -0700 (PDT)
Received: from linta.de (isilmar.linta.de [213.133.102.198]) by cuda.sgi.com
	with ESMTP id saGWC6oYzPLMq3Bn for <xfs@oss.sgi.com>;
	Fri, 26 Jun 2009 14:29:34 -0700 (PDT)
Date: Fri, 26 Jun 2009 23:21:06 +0200
From: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Subject: Re: corrupt file system -- "Structure needs cleaning"
Message-ID: <20090626212106.GH29416@mail.physik.uni-wuppertal.de>
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
	<B1B6286B-1472-4584-8318-F9BB4E74BF8E@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B1B6286B-1472-4584-8318-F9BB4E74BF8E@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Thus spake Felix Blyakher (felixb@sgi.com):

> On Jun 26, 2009, at 2:58 PM, Hendrik Hoeth wrote:
>>
>> This is how I recovered (well, most of the data I had copied is
>> corrupt at the target location):
>
> Some files would not make it to disk when filesystem shut down. I'd
> expect that such files are short. Do you have other indication that
> the files are corrupt?

Of course the last file was short, but even several of the files that
had been copied just before are corrupt (it was a "cp -r" of a few
directories, total ~ 700 MByte, the error appeared when copying the last
directory). Those files have identical lengths as the source files, but
different md5sum. Since it's music, I can hear the corrupt positions;
they are at random positions somewhere in the files.

> Seems like no corruption on disk.
> The system detected in memory corruption and shut the filesystem
> down to avoid writing bad (meta)data to disk. I don't have answer
> for that problem, however you can continue to use the filesystem,
> and may never see this problem again.

Hmmm, at least no corruption as in "inconsistent file system", right?
Still doesn't make me feel well ... I guess I should run a memtest.

> If it happens again, it could be useful to run debug XFS, which may
> point to the problem.

It's the first time that I had problems on this system, and it has been
running continuously for 1 1/2 years now. So until today I thought it
was stable. If the memtest doesn't show anything, I'll keep an eye on
this.

Thanks for the help,

     Hendrik

-- 
"You have to take the most direct road to go instead of your 
 meeting, you have to, this one ended, leave at once the CERN
 domain."         (imprint on the CERN visitor ID cards)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
