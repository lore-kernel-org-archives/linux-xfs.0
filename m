Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 152447CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 12:52:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5B09AC00C
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 10:52:27 -0700 (PDT)
Received: from hauki.tapanitarvainen.fi (hauki.tapanitarvainen.fi
	[80.68.90.32]) by cuda.sgi.com with ESMTP id seTk2jtpZJEFEZcD
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2015 10:52:25 -0700 (PDT)
Date: Thu, 10 Sep 2015 20:52:20 +0300
From: Tapani Tarvainen <tapani@tapanitarvainen.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910175220.GD18940@tarvainen.info>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910150525.GD27863@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910150525.GD27863@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 11:05:25AM -0400, Brian Foster (bfoster@redhat.com) wrote:

> FWIW, the follow up repair did come up clean so it appears (so far) to
> have put the fs back together from a metadata standpoint.

Indeed, now I can mount it. Not that I expect to find much
useful there.

Also, it turns out I have another similar case: another filesystem
(in the same RAID set) failed also, even though it'd initially
mounted without problems. Now it shows the same symptoms,
neither mount nor repair works (have't tried repair -L yet).

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
