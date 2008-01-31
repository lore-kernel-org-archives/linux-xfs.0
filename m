Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Jan 2008 14:39:49 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0VMdbVN004150
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 14:39:41 -0800
Received: from py-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E7DFD65E40
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 14:39:57 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183]) by cuda.sgi.com with ESMTP id wf2CsbNESFwD3ulZ for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 14:39:57 -0800 (PST)
Received: by py-out-1112.google.com with SMTP id j37so943365pyc.4
        for <xfs@oss.sgi.com>; Thu, 31 Jan 2008 14:39:56 -0800 (PST)
Message-ID: <61a567a60801311439n668ed585t7c03a803da57244f@mail.gmail.com>
Date: Thu, 31 Jan 2008 17:39:55 -0500
From: VR <vreikine@gmail.com>
Subject: how to use attr_multi() properly ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,
I am trying to use attr_multi() in my small application on Linux.
It's ArchLinux on Intel laptop
Kernel is 2.6.23
filesystem is XFS
getfattr --version returns 2.4.39

Basically, I want to use EA to store environment variables for an
application - e.g. 'ant' needs ANT_HOME and ANT_LIB , 'jetty' needs
JETTY_HOME etc.
For any given file I want to get EA of "user.env.n" where n is 0...8 ,
so I allocated memory, created attr_multi_op_t array, filled it up
with proper values etc.
Then I make a call to attr_multi() and check the return code. I am
getting the EA values ok, but my question is about return code, errno
and am_error in attr_multiop_t .

Here is the snippets of my code - it's rather long so I cut some pieces out.

const char *ea_env = "env";

int main(int argc, char **argv)
{
	int rc;
	int i,j,k,l,m,n;
	attr_multiop_t ea[EA_SIZE];
	char *ea_buf[EA_SIZE];
	char *ea_argname[EA_MAX_ARG];
	char *ea_envname[EA_MAX_ENV];
	char *ea_name, *ea_path, *ea_ext, *ea_self, *ea_selfs;
	char *tmpval, *tmpvall , *tmpvalll;

	/* initialization */
	rc = 0;			/* return code */
	
	/* common params for all EA */
	for ( i = 0; i < EA_SIZE; i++) {
		ea[i].am_opcode = ATTR_OP_GET ;
		ea[i].am_error = 0;
		ea[i].am_flags = 0;
	}
/*
. skipped not important stuff -
*/

	/* names are in form "env.#" */
	n = strlen(ea_env) + 2 + 1 ;
	/* limit number of args to 16 - 1 hex digit */
	if ((tmpval = malloc( n * (EA_MAX_ENV & 0xF))) == NULL ) {
		perror("malloc: failed to allocate memory for ea_envname") ;
		_exit(errno);
	}
	memset(tmpval, 0, (n * EA_MAX_ARG & 0xF)) ;

	for ( i = 0; i < EA_MAX_ENV & 0xF ; i++) {
		ea_envname[i] = tmpval;
		snprintf(ea_envname[i], n, "%s.%x", ea_env, i) ;
		tmpval +=n ;
		ea_buf[EA_ENV+i] = malloc(EA_MAX_ARGLEN) ;
		if (ea_buf[EA_ENV+i] == NULL) {
			perror("malloc: failed to allocate memory for ea_env" );
			_exit(errno);
		}
		ea[EA_ENV+i].am_attrname = ea_envname[i];
		ea[EA_ENV+i].am_attrvalue = ea_buf[EA_ENV+i];
		ea[EA_ENV+i].am_length = EA_MAX_ARGLEN ;

	}

	if (argc > 1) {
		printf("filename %s:\n",argv[1]);
		rc = attr_multi( argv[1], ea , EA_SIZE, 0);
		if ( rc != 0) {
			printf("rc= %d, errno = %d\n", rc, errno);
		}
		for ( i=0 ; i < EA_SIZE ; i++) {
			if (ea[i].am_error == 0 && (k = strlen(ea[i].am_attrvalue)) ==
ea[i].am_length) {
				printf(" %d:\t%s\t%s\t%d\t%d\n", i, ea[i].am_attrname,
ea[i].am_attrvalue, ea[i].am_length, ea[i].am_error) ;
/* skip not important stuff */
			}
               }
         }
/* skip not important stuff */
return rc;
}

I use gcc 4.2.2 and compile it with "-lattr"
I use "setfattr" to set EA on a test file and let's say I set
user.env.0 and user.env.1 to some values.
I can see those values with "getfattr -d" and I can see them with my
small command but am_error is always 0 - for all " env.#" no matter if
they set or not. I have to use 'strlen()' and compare it to am_length
to check if there is value of EA.
and I am getting "rc = -1" and "errno = -22" (negative 22?), or "rc =
-1" and "errno = 61" depending on EA I set or not set on a test file.
I'd rather have am_error set to proper value if there is no data and
check.



Could you please advise on how to call attr_multi() to get a bunch of
attributes at once properly, or is it better just do attr_get() in a
loop ?

Sincerely,
Vladimir
