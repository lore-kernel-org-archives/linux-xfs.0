Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC3E4805C
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 16:57:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5B6CAC003
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 14:57:34 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id lB1hIsls47RV3QH4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 14:57:33 -0800 (PST)
Date: Mon, 4 Mar 2013 14:57:24 -0800
From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130304225724.GB7783@localhost>
References: <20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
	<20130303231905.0efd6d08@spider.haslach.nod.at>
	<5133D15A.9010600@sandeen.net>
	<20130303235341.7470085e@spider.haslach.nod.at>
	<5133D573.3050106@sandeen.net> <20130304004229.GK23616@dastard>
	<20130304210522.GA7783@localhost>
	<20130304230922.20f6c05a@spider.haslach.nod.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130304230922.20f6c05a@spider.haslach.nod.at>
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
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Mar 04, 2013 at 11:09:22PM +0100, Richard Weinberger wrote:
> Am Mon, 4 Mar 2013 13:05:23 -0800
> schrieb Joel Becker <jlbec@evilplan.org>:
> > > Really, xfstests is not designed for testing cluster filesystems in
> > > clustered environments. If we really want to support clustered
> > > filesystems and cluster wide operations, then we need to think
> > > about how to architect multi-host support into xfstests sanely.
> > > Clustered filesystems are not the only people that could make use of
> > > such functionality (NFS and CIFS come to mind).... ;)
> > 
> > I'm much happier with the "check for other cluster mounts" approach
> > rather than avoiding fsck entirely.  We like xfstests in the local or
> > single-node cases to behave exactly as one would expect.
> > 
> > We do run xfstests on multiple nodes in a cluster, but by hand and
> > with our own cleanup.  Obviously support for automating that would be
> > awesome :-)
> 
> Can you share your cleanup code?

It's not code, unless you count DNA and neuron connections...

Joel

> 
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

			http://www.jlbec.org/
			jlbec@evilplan.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
