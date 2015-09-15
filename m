Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEA227F37
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:37:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1FC930404E
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:36:58 -0700 (PDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
	[209.85.212.170]) by cuda.sgi.com with ESMTP id
	sSClbvHYPuFIRFFh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:36:56 -0700 (PDT)
Received: by wicgb1 with SMTP id gb1so19897580wic.1
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:36:55 -0700 (PDT)
Received: from teal.hq.k1024.org (178-83-234-80.dynamic.hispeed.ch.
	[178.83.234.80]) by smtp.gmail.com with ESMTPSA id
	kb5sm20046970wjc.17.2015.09.15.02.36.53 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Tue, 15 Sep 2015 02:36:53 -0700 (PDT)
Date: Tue, 15 Sep 2015 11:36:53 +0200
From: Iustin Pop <iustin@k1024.org>
Subject: Re: xfsrestore and multi-tape backups
Message-ID: <20150915093653.GA31370@teal.hq.k1024.org>
References: <20150908144806.GA22811@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150908144806.GA22811@teal.hq.k1024.org>
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
To: xfs@oss.sgi.com

On 2015-09-08 16:48:06, Iustin Pop wrote:
> Hi all,
> 
> Sorry for the long email. I don't understand how xfsrestore is supposed
> to work when restoring a dump spanning multiple tapes, maybe someone can
> explain things to me.

Anyone? A TL;DR version is:

- restoring from tape 1 doesn't ask for the 2nd, reads finishes with
  "failed; end of file" but restore is SUCCESS
- restoring from tape 2 asks for more tapes, inserting tape 1 continues
  the restore but at the end asks for more tapes

So what's the correct way to restore a multi-tape dump? (Man page says
to start with tape 1, but that doesn't seem to be working).

thanks in advance,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
