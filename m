Return-Path: <BATV+ac29816878cb286aebda+2110+infradead.org+hch@bombadil.srs.infradead.org>
Date: Wed, 3 Jun 2009 15:38:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] xfstests: add aio-dio-regress tests
Message-ID: <20090603193845.GB4516@infradead.org>
References: <4A255E80.9000209@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A255E80.9000209@sandeen.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>
List-ID: <xfs>

On Tue, Jun 02, 2009 at 12:16:48PM -0500, Eric Sandeen wrote:
> +AIO_TEST=aio-dio-extend-stat
> +
> +rm -f $TEST_DIR/aio-testfile
> +echo "==${AIO_TEST}=="
> +src/aio-dio-regress/$AIO_TEST $TEST_DIR/aio-testfile 2>&1

the AIO_TEST variable seems superflous in all these tests.  Also
the echo isn't really strictly needed if only running one thing
anyway.

Modulo these nitpicks looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>
