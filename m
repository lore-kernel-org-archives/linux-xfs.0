Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6DBS8Fo044520 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 06:28:09 -0500
Subject: Re: How to simulate journal corruption
References: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl>
From: Olaf Weber <olaf@sgi.com>
Date: Mon, 13 Jul 2009 13:28:45 +0200
In-Reply-To: <SNT109-W2390816D3EF297CE0D07DEEC220@phx.gbl> (crow al's message
	of "Mon, 13 Jul 2009 13:55:05 +0800")
Message-ID: <bzymy78rfde.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: crow al <al-john@hotmail.com>
Cc: xfs@oss.sgi.com

crow al writes:

> Hi, there

> I'm a QA engineer from Cisco. I'm working on a test case concerning
> XFS journal playback failure, which needs to manually inject error
> to XFS.

> I did some google work but get no luck. Then I think maybe XFA-QA
> could give me some advice. That why I come to here.

> Is there anyone could tell me how to inject error into XFS or is
> there any tool could be used?

For clobbering a filesystem image in general you can use fsfuzz.
  http://people.redhat.com/sgrubb/files/fsfuzzer-0.7.tar.gz

If log replay is of particular interest, you might want to modify that
code to target the XFS log in particular.

The XFS QA tests do not, IIRC, contain tests that deliberately trash
the XFS log, but there are some tests that exercise log replay, and
you may want to take a look at those to see ways to get an XFS
filesystem image with a non-empty log to replay.

Note that kernel-side, if log replay fails the expected/desired result
is that kernel won't mount the filesystem.

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
