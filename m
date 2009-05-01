Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n41M4XOD029887 for <xfs@oss.sgi.com>; Fri, 1 May 2009 17:04:33 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FF4F8F8071
	for <xfs@oss.sgi.com>; Fri,  1 May 2009 15:04:32 -0700 (PDT)
Message-Id: <EE575CDF-D956-45DC-A58C-D17CF22F8C0A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090429144734.GA15044@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: release.sh, take two
Date: Fri, 1 May 2009 17:04:31 -0500
References: <20090429141108.GA14578@infradead.org>
	<20090429144734.GA15044@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Apr 29, 2009, at 9:47 AM, Christoph Hellwig wrote:

> On Wed, Apr 29, 2009 at 10:11:08AM -0400, Christoph Hellwig wrote:
>> A new release script, now using Makepkgs to simply things.  Needs to
>> be run from the repository directory.
>>
>> Anyone fine with commiting a copy to each of the repositories?
>
> And now with actual content:

Looks good.
We should also add release.sh to .gitignore.

Felix

>
>
>
> #!/bin/sh
>
> . VERSION
>
> version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
> date=`date +"%-d %B %Y"`
>
> echo "Updating CHANGES"
> sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/ 
> CHANGES.tmp && \
> 	mv doc/CHANGES.tmp doc/CHANGES
>
> echo "Commiting CHANGES update to git"
> git-commit -a -m "${version} release"
>
> echo "Tagging git repository"
> git-tag v${version}
>
> echo "Creating source tarball in build/tar/"
> ./Makepkgs
>
> echo "Done."
> echo "Please remember to push out tags using \"git push --tags\""
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
