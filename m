Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C31747F52
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 03:23:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 980D5304053
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 01:23:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ANjYpR1HQ5eLVzPn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 01:23:27 -0800 (PST)
Date: Fri, 22 Nov 2013 01:23:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Filesystem writes on RAID5 too slow
Message-ID: <20131122092325.GA8512@infradead.org>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
	<CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
	<CACtJ3HZdF+y9-f6v8Zo6D=uFVPsqZZbQy2vVeXmfTA9a7vwAwg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACtJ3HZdF+y9-f6v8Zo6D=uFVPsqZZbQy2vVeXmfTA9a7vwAwg@mail.gmail.com>
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
To: Martin Boutin <martboutin@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 21, 2013 at 11:35:14AM -0500, Martin Boutin wrote:
> Sorry for the spam but I just noticed that the XFS stripe unit does not
> match the strip unit of the underlying RAID device. I tried to do a
> mkfs.xfs with a stripe of 512KiB but mkfs.xfs complains that the
> maximum stripe width is 256KiB.

Yeah.  Btw, I've generally seen best results using 32k stripes, but that
should only matter for log intensive loads and not simple writes.
Similarly your 32mb log seems awfully small, but not really relevant for
this workload.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
