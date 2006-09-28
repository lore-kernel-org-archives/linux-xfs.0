Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 17:40:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8S0e5aG020813
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 17:40:07 -0700
Message-ID: <451B1A06.4000507@sgi.com>
Date: Thu, 28 Sep 2006 10:40:38 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db ring command
References: <200609270444.AA04551@TNESG9305.tnes.nec.co.jp>
In-Reply-To: <200609270444.AA04551@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

Utako Kusaka wrote:
> This patch fixes the issue that
> xfs_db ring [index] command don't move to specified index.
> 
> Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
> ---
> 
> --- xfsprogs-2.8.11-orgn/db/io.c	2006-06-26 14:01:14.000000000 +0900
> +++ xfsprogs-2.8.11/db/io.c	2006-09-26 16:59:40.000000000 +0900
> @@ -352,7 +352,7 @@ ring_f(
>  		return 0;
>  	}
>  
> -	index = (int)strtoul(argv[0], NULL, 0);
> +	index = (int)strtoul(argv[1], NULL, 0);
>  	if (index < 0 || index >= RING_ENTRIES)
>  		dbprintf("invalid entry: %d\n", index); 
> 

Hi there,

Thanks for that.
I'll check it in shortly.

Aside:
I think I can see how this happened.
It must have been due to porting from IRIX to Linux.
On IRIX the db commands removed the command name,
and just passed in the arguments to the specific command
function; they did:

ON IRIX:
------------
command(
         int             argc,
         char            **argv)
{
         char            *cmd;
         const cmdinfo_t *ct;

         cmd = argv[0];
         ct = find_command(cmd);
         if (ct == NULL) {
                 dbprintf("command %s not found\n", cmd);
                 return 0;
         }
   -->   argc--;
   -->   argv++;
         if (argc < ct->argmin || (ct->argmax != -1 && argc > ct->argmax)) {
         ...
         return ct->cfunc(argc, argv);

-------------

But on Linux we pass through the command name as well:
--------------
int
command(
         int             argc,
         char            **argv)
{
         char            *cmd;
         const cmdinfo_t *ct;

         cmd = argv[0];
         ct = find_command(cmd);
         if (ct == NULL) {
                 dbprintf("command %s not found\n", cmd);
                 return 0;
         }
         if (argc-1 < ct->argmin || (ct->argmax != -1 && argc-1 > ct->argmax)) {
	...
	return ct->cfunc(argc, argv);
--------------

So I hope no more of these mistakes have happened because I'd
imagine many of the commands would have had to change.
I noticed that someone fixed up part of ring_f command but not the part
that you found/fixed.

Cheers,
Tim.
