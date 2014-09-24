Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 146E67F61
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:11:46 -0500 (CDT)
Date: Wed, 24 Sep 2014 18:11:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07a/13] xfsprogs: add trie generator for UTF-8.
Message-ID: <20140924231145.GK4482@sgi.com>
References: <20140918195650.GI19952@sgi.com> <20140918203114.GN4482@sgi.com>
	<20140919160612.GF4482@sgi.com>
	<1411497259.4842.163.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411497259.4842.163.camel@localhost.localdomain>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

Hi Roger,

On Tue, Sep 23, 2014 at 07:34:19PM +0100, Roger Willcocks wrote:
> On Fri, 2014-09-19 at 11:06 -0500, Ben Myers wrote:
> > +#define AGE_NAME       "DerivedAge.txt"
> > +#define CCC_NAME       "DerivedCombiningClass.txt"
> > +#define PROP_NAME      "DerivedCoreProperties.txt"
> > +#define DATA_NAME      "UnicodeData.txt"
> > +#define FOLD_NAME      "CaseFolding.txt"
> > +#define NORM_NAME      "NormalizationCorrections.txt"
> > +#define TEST_NAME      "NormalizationTest.txt"
> 
> Is there a reason why you're using multiple text-based data files (and
> hand-parsing them) when there's an xml formatted flat file available ?
> 
> http://www.unicode.org/Public/UCD/latest/ucdxml/

The UCD files being parsed are the authoritative source.  Check out
ucdxml.readme.txt.

> And a 2nd question - why does the trie need to encode "the the unicode
> version in which the codepoint was assigned an interpretation" ?

You need to know whether a given code point is assigned in the version
of Unicode you're normalizing for.  Unicode 8 is supposed to release
June/July 2015 (see http://www.unicode.org/versions/), but filesystems
you created this year will still need the version 7 normalization.
There is still some plumbing to do to pass the version along with the
string for normalization.

I think you bring up a good point, but we'll need to support multiple
versions in the long run.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
